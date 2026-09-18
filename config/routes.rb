Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "recipes#home"

  resources :recipes, only: %i[index show]

  get  "login",  to: "sessions#new",     as: :login
  post "login",  to: "sessions#create"
  post "logout", to: "sessions#destroy", as: :logout

  namespace :admin do
    resources :recipes, only: %i[index new create destroy]
  end
end
