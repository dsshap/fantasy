jQuery ->
  if $('.load_more').length
    $(window).scroll ->
      url = $('.load_more a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.load_more').text("Fetching more products...")
        $.getScript(url)
    $(window).scroll()