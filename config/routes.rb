Rails.application.routes.draw do
  root 'homepage#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: 'new_session_path'
    get 'signup', to: 'devise/registrations#new'
  end

  resources :users, only: [:show]

  resources :users do
    resources :places, only: %i[index create update destroy],
                       controller: 'users/places'
  end

  resource :global_map, only: %i[show],
                        controller: 'global_map'

  scope :global_map do
    get 'users', to: 'global_map#users', as: 'global_map_users'
  end
end
