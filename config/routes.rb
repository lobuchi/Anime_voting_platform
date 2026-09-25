Rails.application.routes.draw do

  resources :users, only: :show
  resource :profile, only: [:edit, :update] 
  resource :session
  resource :registration, only: [:new, :create]
  resources :passwords, param: :token

  resources :animes do
    resources :votes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "animes#index"
end
