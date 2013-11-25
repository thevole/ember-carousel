#= require jquery
#= require jquery_ujs
#= require foundation
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require app

# for more details see: http://emberjs.com/guides/application/
@App = Ember.Application.create
  rootElement: '#ember-app'
  LOG_TRANSITIONS: true


$ ->
  $(document).foundation()
