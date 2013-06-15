# ------------------------------------------------------------------------------
# 
# Object responsible for cards within the stack
# 
# ------------------------------------------------------------------------------

define ['jquery','lib/extends/events'], ($, EventEmitter) ->

  class Stack

    $.extend(@prototype, EventEmitter)

    LISTENER = '#js-card-holder'

    # @params {}
    # el: {string} selector for parent element
    # list: {string} delimited list of selectors for cards
    constructor: (args) ->
      $.extend @config, args
      @$el = $(args.el)
      @$list = @$el.find(args.list)
      @init() unless @$el.length is 0

    init: ->
      @listen()
      @broadcast()


    # Subscribe
    listen: ->
      $(LISTENER).on ':cards/request', =>
        @_block()
        @_addLoader()

      $(LISTENER).on ':cards/received', (e, data) =>
        @_removeLoader()
        @_clear()
        @_add(data.content)

      $(LISTENER).on ':cards/append/received', (e, data) =>
        @_add(data.content)

      $(LISTENER).on ':page/request', =>
        @_block()
        @_addLoader()

      $(LISTENER).on ':page/received', (e, data) =>
        @_removeLoader()
        @_clear()
        @_add(data.content)

      $(LISTENER).on ':search/change', (e) =>
        @_block()


    # Publish
    broadcast: ->
      # Cancel search and show info card
      @$el.on 'click', '.card--disabled', (e) =>
        e.preventDefault()
        @_unblock()
        @trigger(':search/hide')

      # Clear all filters when there are no results
      @$el.on 'click', '.js-clear-all-filters', (e) =>
        e.preventDefault()
        @trigger(':filter/reset')

      # Adjust dates when there are no results
      @$el.on 'click', '.js-adjust-dates', (e) =>
        e.preventDefault()
        @trigger(':search/change')


    # Private

    _addLoader: ->
      @$el.addClass('is-loading')

    _removeLoader: ->
      @$el.removeClass('is-loading')

    _block: ->
      @$list.addClass('card--disabled')

    _unblock: ->
      @$list.removeClass('card--disabled')

    _clear: () ->
      @$list.remove()

    _add: (newCards)->
      $cards = $(newCards).addClass('card--invisible')
      @$el.append($cards)
      @_show($cards)

    _show: (cards) ->
      i = 0
      insertCards = setInterval( ->
        if i isnt cards.length
          $(cards[i]).removeClass('card--invisible')
          i++
        else
          clearInterval insertCards
      , 20)