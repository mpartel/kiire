ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'index'
  map.resource :session
end
