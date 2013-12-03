TaskFromOnApp::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :tickets, only: [:show, :new, :create]
  get 'history/tickets/:encrypted_email' => 'tickets#index', as: :history

  root 'home#index'
end
