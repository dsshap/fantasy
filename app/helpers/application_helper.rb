module ApplicationHelper
  def cc_html(options = {}, &blk)
    attrs = options.map { |(k, v)| %( #{h k}="#{h v}") }.join('')
    [ %(<!--[if lt IE 7 ]><html#{attrs} class="ie6"><![endif]-->),
      %(<!--[if IE 7 ]><html#{attrs} class="ie7"><![endif]-->),
      %(<!--[if IE 8 ]><html#{attrs} class="ie8"><![endif]-->),
      %(<!--[if IE 8 ]><html#{attrs} class="ie9"><![endif]-->),
      %(<!--[if (gt IE 9)|!(IE)]><!--><html#{attrs}><!--<![endif]-->),
      capture_haml(&blk).strip,
      "</html>"
    ].join("\n")
  end
  def event_autolink(event_parts)
    event_parts.map do |part|
      case part.content
      when Hash
        link_to part.content['name'], send("admin_#{part.content['class_name'].underscore}_path", part.content['id'])
      else
        part.content
      end
    end.join(' ').html_safe
  end
  def flash_type(type)
    case type
    when :alert
      'alert-block'
    when :error
      'alert-error'
    when :notice
      'alert-info'
    when :success
      'alert-success'
    else
      type.to_s
    end
  end
end
