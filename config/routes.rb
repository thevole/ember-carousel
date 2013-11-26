EmberCarousel::Application.routes.draw do
  root to: 'application#index'

  get '*parms', to: 'application#index'
end
