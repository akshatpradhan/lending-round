LendingRound::Application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    invitations: "users/invitations"}

  devise_scope :user do
    get 'signin', to: 'devise/sessions#new', as: :signin
    get 'signout', to:  'devise/sessions#destroy', as: :signout
  end

  resources :notes
  resources :users, :only => [:index, :show, :edit, :update ]

  root :to => "home#index"
end
