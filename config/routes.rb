Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "houses#index"

  resources :houses, only: [ :index, :show ]
  resource :import, only: [ :new, :create ]
end
