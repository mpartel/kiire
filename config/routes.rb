ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.resource :session
  map.resources :users
  map.resource :settings
  map.resources :places
  map.resource :info

  map.user_places ':username', :controller => 'index', :action => 'index'
end
