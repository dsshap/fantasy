ActiveAdmin.register_page 'Events' do

  content do
    table class: 'index_table' do
      thead do
        tr do
          th 'Event'
          th 'When'
        end
      end
      tbody do
        (@events = Kaminari.paginate_array(Evently.desc(:created_at)).page(params[:page]).per(50)).each do |event|
          tr class: cycle('odd', 'even') do
            td event_autolink(event.event_parts)
            td do
              span style: 'white-space: nowrap' do
                event.created_at.strftime("%b %d, %Y %I:%M:%S %p")
              end
            end
          end
        end
      end
    end

    div id: 'index_footer' do
      paginate @events
    end
  end

end