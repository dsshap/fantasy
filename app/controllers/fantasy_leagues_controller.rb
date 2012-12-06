class FantasyLeaguesController < ApplicationController
  before_filter :authenticate_user!, except: :join_league
  respond_to *Mime::SET.map(&:to_sym)# if mimes_for_respond_to.empty?

  def new
    @fantasy_league = current_user.fantasy_leagues.new
  end

  def create
    fantasy_league = current_user.fantasy_leagues.new params[:fantasy_league]
    if fantasy_league.save
      flash[:notice] = "Created league: #{fantasy_league.name}"

      Evently.record(current_user, 'created league', fantasy_league)

      respond_with fantasy_league, :location => fantasy_league_path(fantasy_league)
    else
      respond_with fantasy_league
    end
  end

  def show
    @fantasy_league = FantasyLeague.find(params[:id]) rescue nil

    unless @fantasy_league.nil?
      @current_user_participant = @fantasy_league.participants.find_by_user(current_user)
      @league_owner = @current_user_participant.is_owner
      unless params[:week_number].nil? or (params[:week_number].to_i > @fantasy_league.current_week_number or params[:week_number].to_i < 0)
        @week = @fantasy_league.weeks.where(week_number: params[:week_number]).first
      end

      if @week.nil?
        @week = @fantasy_league.current_week
      end
      @pending_inv = @fantasy_league.get_pending_invitations
      @team = @week.current_team(@current_user_participant)
      @posts = @fantasy_league.get_message_board.posts.desc(:created_at).page(params[:page]).per(10)
      @new_post = MessageBoardPost.new
      @total_points = @fantasy_league.get_total_league_points

      Evently.record(current_user, 'viewed', @fantasy_league, @week)
    else
      redirect_to root_path
    end
  end

  def scoring_settings
    @fantasy_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil

    if @fantasy_league.nil?
      flash[:error] = "Fantasy League does not exist"
      redirect_to root_path
    end

  end

  def new_invitation
    @fantasy_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil
    email = params[:email]

    unless @fantasy_league.nil? or email.nil?
      if @fantasy_league.invitations.all_in(email: email, status: 'pending').count.zero?
        if @fantasy_league.invitations.where(email: email).count.zero?

          inv = @fantasy_league.invitations.new email: email, inviter_email: current_user.email

          if inv.save
            flash[:success] = "Successfully invited #{email}!"
          else
            flash[:error] = inv.errors.full_messages
          end
        else
          flash[:error] = "An invitation was already accepted for #{email}"
        end
      else
        flash[:error] = "An invitation is already pending for #{email}"
      end
      redirect_to fantasy_league_path(@fantasy_league)
    else
      redirect_to root_path
    end
  end

  def join_league
    invitation_id = params[:invitation_id]
    inv = FantasyInvitation.find(invitation_id) rescue nil
    unless inv.nil? or inv.accepted?
      if inv.fantasy_league.id.to_s.eql?(params[:fantasy_league_id])
        if user_signed_in?
          if inv.email.eql?(current_user.email)
            inv.join_league(current_user)
          end
        else
          set_invitation_into_session(inv.id)
          unless User.where(email: inv.email).first.nil?
            new_user_session_path
          else
            new_user_registration_path
          end
        end
      end
    end
    redirect_to root_path
  end

  def resend_invitation
    invitation_id = params[:invitation_id]
    inv = FantasyInvitation.find(invitation_id) rescue nil
    unless inv.nil? or inv.accepted?
      inv.send_invite
      Evently.record(current_user, 're-sent invitation', inv)
      flash[:success] = "Successfully resent inviation to #{inv.email}"
      redirect_to fantasy_league_path(inv.fantasy_league) and return
    end
    flash[:error] = "Invitation does not exist"
    redirect_to fantasy_league_path(params[:fantasy_league_id])
  end

  def edit
    @fantasy_league = FantasyLeague.find(params[:id])
  end

  def update
    fantasy_league = FantasyLeague.find(params[:id])
    fantasy_league.update_attributes params[:fantasy_league]
    if fantasy_league.save
      flash[:notice] = "Updated League Settings"
      Evently.record(current_user, 'updated league settings', @fantasy_league)
      respond_with fantasy_league, :location => fantasy_league_path(fantasy_league)
    else
      respond_with fantasy_league
    end
  end

  def switch_player

    unless params[:fantasy_league_id].nil?
      f_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil
      unless f_league.nil?
        f_week = f_league.current_week
        current_user_participant = f_league.participants.find_by_user(current_user)
        f_team = f_week.current_team(current_user_participant)
        s_player = SportsLeague.where(name: "football").first.current_week.players.find(params[:s_player_id]) #rescue nil
        f_player = f_team.players.find(params[:f_player_id]) #rescue nil

        unless s_player.nil?

          if s_player.eligible?
            used_players = current_user_participant.get_used_players(f_player.position)
            unless used_players.include?(s_player)


              f_player.player = s_player
              f_player.save

              Evently.record(current_user, "added", f_player, 'to', f_team)

              flash[:success] = "Successfully added #{s_player.name}"
              redirect_to fantasy_league_fantasy_team_path(f_league, f_team)

            else
              flash[:error] = "Sports Player has already been used in previous weeks"
              redirect_to fantasy_league_fantasy_team_path(f_league, f_team)
            end
          else
            flash[:error] = "Sports Player is not eligable to be added to your team"
            redirect_to fantasy_league_fantasy_team_path(f_league, f_team)
          end

        else
          flash[:error] = "Sports Player does not exist"
          redirect_to fantasy_league_fantasy_team_path(f_league, f_team)
        end
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end

  end

  def add_message_board_post
    unless params[:fantasy_league_id].nil?
      f_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil
      unless f_league.nil?

        msg_b = f_league.get_message_board
        post = msg_b.posts.new params[:message_board_post]
        post.participant = current_user_participant(f_league)

        if post.valid?
          post.save
          flash[:notice] = "posted to message board"
          redirect_to fantasy_league_path(f_league)
        else
          flash[:notice] = "message not posted because #{post.errors.full_messages}"
          redirect_to fantasy_league_path(f_league)
        end


      else
        flash[:error] = "Fantasy League does not exist"
        redirect_to root_path
      end
    else
      flash[:error] = "Fantasy League id was not passed"
      redirect_to root_path
    end

  end

  def change_name
    unless params[:fantasy_league_id].nil? or params[:fantasy_participant][:team_name].nil?
      f_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil
      unless f_league.nil?

        participant = f_league.participants.find_by_user(current_user) rescue nil

        unless participant.nil?

          participant.team_name = params[:fantasy_participant][:team_name]
          participant.save
          Evently.record(current_user, 'changed name team to', participant.team_name)
          flash[:success] = "Successfully changed team name to #{participant.team_name}"
          redirect_to fantasy_league_fantasy_team_path(f_league, participant.get_current_team          )

        else
          flash[:error] = "Participant does not exist"
          redirect_to fantasy_league_path(f_league)
        end

      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end

  end

end