App.SlideCarouselComponent = Ember.Component.extend
  tagName: 'div'
  classNames: ['carousel']

  interval: 5000

  shownElement: null

  isPaused: false

  showing: false

  pauseMode: (->
    if @get('isPaused') then "Play" else "Pause"
  ).property('isPaused')

  actions: {
    togglePause: ->
      @set 'isPaused', (not @get 'isPaused')

    nextSlide: ->
      unless @get 'showing'
        @set 'showing', true
        next = @nextSibling()
        @set 'isPaused', true
        @clear_timer()
        @showElement(next)
#        @nextElement()
        @resetShowing(1000)

    prevSlide: ->
      unless @get 'showing'
        @clear_timer()
        @set 'showing', true
        prev = @prevSibling()
        @set 'isPaused', true
        @showElement(prev)
#        @nextElement()
        @resetShowing(1000)
  }

  resetShowing: (delay) ->
    Ember.run.later(
      this,
      -> @set 'showing', false,
      delay
    )

  clear_timer: ->
    timer_id = @get 'runLater'
    if timer_id?
      Ember.run.cancel timer_id
      @set 'runLater', null

  resume: (->
    if not @get('isPaused')
      @nextElement()
    else
      @clear_timer()
  ).observes('isPaused')

  didInsertElement: ->
    # console.info 'Did insert carousel'
    @set 'shownElement', null
    firstItem = @$('li:first')
    @showElement(firstItem)
    @nextElement()


  showElement: (newElementToShow) ->
    oldElement = @get 'shownElement'
    newElementToShow.addClass 'show'
    @removeElement(oldElement)
    @set 'shownElement', newElementToShow

  removeElement: (oldElement) ->
    if oldElement?
      oldElement.removeClass 'show' unless $('.show').length == 1

  willDestroyElement: ->
    # console.info "Will destroy carousel"
    @set 'shownElement', null

  runLater: null

  prevSibling: ->
    shown = @get('shownElement')
    prevSibling = $(shown).prev()
    if prevSibling.length == 0
      prevSibling = @$('li[data-slide]').last()
    prevSibling

  nextSibling: ->
    shown = @get('shownElement')
    nextSibling = $('~ li', shown).first()
    if nextSibling.length == 0
      nextSibling = @$('[data-loop]').first()
    if nextSibling.length == 0
      nextSibling = @$('li:first')
    nextSibling

  nextElement: ->
    timer_id = Ember.run.later(
      this,
      ->
        shown = @get('shownElement')
        if shown?
          @showElement(@nextSibling())
          @nextElement()
      , @get 'interval'
    )
    @set 'runLater', timer_id

