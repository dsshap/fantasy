module LayoutHelper
  def title(page_title=nil, show_title = true)
    content_for(:title) { h(page_title.to_s) } unless page_title.nil?
  end

  def stylesheet(*args)
    content_for(:stylesheets) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:javascript) { javascript_include_tag(*args) }
  end

  def fantasy_current_page?(url1, url2)
    is_current_page = false
    if current_page?(url1)
      is_current_page = true
    end
    if current_page?(url2)
      is_current_page = true
    end
    is_current_page
  end
end