Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :applications, :authorizations, :authorized_applications, :tokens, :token_info
  end

  namespace :api do
    namespace :v1 do
      devise_for :users, skip: [:registrations, :passwords], skip_helpers: true, controllers: {
        confirmations: 'api/v1/confirmations'
      }
      use_doorkeeper do
        controllers tokens: 'tokens'
        skip_controllers :authorizations, :applications, :authorized_applications, :token_info, :tokens, :confirmations
      end
      resources :keywords, only: [:index, :create, :show]
      resources :private_items, only: :index
      resources :tokens, only: [:create]
      resources :registrations, only: [:create]
      resources :search_results, only: [:index]
    end
  end

  resources :public_items, only: :index
  resources :private_items, only: :index
  resources :success_messages, only: :index
end
