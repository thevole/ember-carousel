App.SlideCarouselComponent = Ember.Component.extend
  tagName: 'div'
  classNames: ['carousel']

  interval: 5000

  shownElement: null

  isPaused: false

  pauseMode: (->
    if @get('isPaused') then "Play" else "Pause"
  ).property('isPaused')

  actions: {
    togglePause: ->
      @set 'isPaused', (not @get 'isPaused')

    nextSlide: ->
      next = @nextSibling()
      # @set 'isPaused', true
      @clear_timer()
      @showElement(next)
      @nextElement()

    prevSlide: ->
      prev = @prevSibling()
      # @set 'isPaused', true
      @clear_timer()
      @showElement(prev)
      @nextElement()
  }

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
    # console.log "Showing #{$(newElementToShow).attr('id')}"
    oldElement = @get 'shownElement'
    newElementToShow.addClass 'front animate show'
    # console.log "Removing #{$(oldElement).attr('id')}"
    @removeElement(oldElement)
    @set 'shownElement', newElementToShow

  removeElement: (oldElement) ->
    if oldElement?
      oldElement.removeClass 'front'
      Ember.run.later(
        oldElement,
        ->
          @removeClass 'animate show' unless $('.show').length == 1
        , @get('interval') * 0.6
      )

  willDestroyElement: ->
    # console.info "Will destroy carousel"
    @set 'shownElement', null

  runLater: null

  prevSibling: ->
    shown = @get('shownElement')
    prevSibling = $(shown).prev()
    if prevSibling.length == 0
      prevSibling = @$('li:last')
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

