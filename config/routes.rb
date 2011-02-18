Kiire::Application.routes.draw do
  match '/' => 'index#index', :as => 'root'
  resource :session
  resources :users
  resource :settings
  resources :places
  resource :info
  match ':username' => 'index#index', :as => :user_places
end
