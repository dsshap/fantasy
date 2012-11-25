require 'sidekiq/web'

Fantasy::Application.routes.draw do

   namespace :admin do

    resources :fantasy_leagues do
      resources :fantasy_weeks, :only => [:show, :edit, :update] do
        resources :fantasy_teams, :only => [:show, :edit, :update] do
        end
      end
      get :new_fantasy_week
    end

    resources :sports_leagues do
      resources :sports_weeks, :only => [:show, :edit, :update, :destroy] do
        resources :sports_players do
          get :in_play
          get :done_playing
        end
        get :activate_next_week
      end
      get :new_sports_week
    end

   end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions' }

  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.instance_of?(AdminUser) }
  constraints constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  authenticated :user do
    root :to => 'dashboard#show'
  end

  root :to => "static#home"

  match '/dashboard' => 'dashboard#show', via: :get, as: :dashboard

  resources :fantasy_leagues, except: :delete do
    post :new_invitation
    get "/join_league/:invitation_id" => "fantasy_leagues#join_league", as: :join_league
    get "/switch_player/:s_player_id/to/:f_player_id" => "fantasy_leagues#switch_player", as: :switch_player
    resources :fantasy_teams, only: [:show, :edit, :update] do
      get "/drop_player/:f_player_id" => "fantasy_teams#drop_player", as: :drop_player
    end
    resources :sports_players, only: :index do

    end
  end



  post '/teams' => 'fantasy_teams#index'
  post '/team' => 'fantasy_teams#show'

  # resources :fantasy_teams, only: [:index, :show] do

  # end

  %w[home contact faq].each do |page|
    get page => 'static#'+page
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
