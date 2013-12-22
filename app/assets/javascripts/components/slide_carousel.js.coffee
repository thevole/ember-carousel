App.SlideCarouselComponent = Ember.Component.extend
  tagName: 'div'
  classNames: ['carousel']

  interval: 5000

  shownElement: null

  isPaused: false

  pauseMode: (->
    if @get('isPaused')
      "Play"
    else
      "Pause"
  ).property('isPaused')

  actions: {
    togglePause: ->
      @set 'isPaused', (not @get 'isPaused')
  }

  resume: (->
    if not @get('isPaused')
      @nextElement()
    else
      timer_id = @get 'runLater'
      if timer_id?
        Ember.run.cancel timer_id
        @set 'runLater', null
  ).observes('isPaused')

  didInsertElement: ->
    console.info 'Did insert carousel'
    @set 'shownElement', null
    firstItem = @$('li:first')
    @showElement(firstItem)
    @nextElement()

  showElement: (newElementToShow) ->
    oldElement = @get 'shownElement'
    newElementToShow.addClass 'front animate show'
    @removeElement(oldElement)
    @set 'shownElement', newElementToShow

  removeElement: (oldElement) ->
    if oldElement?
      oldElement.removeClass 'front'
      Ember.run.later(
        oldElement,
        ->
          @removeClass 'animate show'
        , @get('interval') * 0.6
      )

  willDestroyElement: ->
    console.info "Will destroy carousel"
    @set 'shownElement', null

  runLater: null

  nextElement: ->
    timer_id = Ember.run.later(
      this,
      ->
        shown = @get('shownElement')
        if shown?
          nextSibling = $('~ li', shown).first()
          if nextSibling.length == 0
            nextSibling = @$('[data-loop]').first()
          if nextSibling.length == 0
            nextSibling = @$('li:first')
          @showElement(nextSibling)
          @nextElement()
      , @get 'interval'
    )
    @set 'runLater', timer_id
