# ------------------------------------------------------------------------------
# Handling pjax calls
# @constructor
# @param {#object} args - defined by config below
# ------------------------------------------------------------------------------

define ['jquery', 'jplugs/jquery.pjax'], ($) ->

  class Lpjax

    config =
      container   : '#js-pjax-container'
      parent      : 'body'
      type        : 'GET'
      timeout     : 650
      animate     : true
      animateType : 'each'
      url         : ''
      data        : ''
      success     : ->
      error       : ->

    init = ->
      if $.pjax.defaults isnt undefined
        $.pjax.defaults.scrollTo = false
      
      init = ->
        $(config.parent).off('pjax:end')
        $(config.parent).off('pjax:error')

    setupCardsAnimation = ->
      $(config.parent).on 'pjax:animate', (e, data) ->
        cardsContainer = data.contents.filter('.results')
        cards = data.contents.find('.card').css('opacity', '0')
        data.container.html(data.contents)
        if (config.animateType == 'each')
          i = 0
          insertCards = setInterval(->
            if i isnt cards.length
              $(cards[i]).css "opacity", "1"
              i++
            else
              clearInterval insertCards
          , 50)
        else
          cards.css('opacity', '1')

    bindEvents = ->
      $(config.parent).on 'pjax:end', config.success
      $(config.parent).on 'pjax:error', config.error


    constructor: (args) ->
      $.extend config, args
      init()
      bindEvents()
      if config.animate == true then setupCardsAnimation()

      $.pjax
        url       : config.url
        container : config.container
        data      : config.data
        type      : config.type
        timeout   : config.timeout
        animate   : config.animate