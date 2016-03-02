require 'sidekiq/web'

Rails.application.routes.draw do
  # Routes are matched top to bottom.

  match '/auth/:provider/callback', to: 'authentications#create', via: :all
  get '/auth/failure', to: 'home#auth_failure'
  devise_for :users, controllers: {
    registrations: 'registrations',
    confirmations: 'confirmations',
    sessions: 'sessions',
    passwords: 'passwords'
  }
  devise_scope :user do
    get   '/profile', to: 'registrations#profile', as: :user_profile
    match '/profile', to: 'registrations#profile', as: :update_user_profile, via: [:put,:patch]
    match '/change_password', to: 'registrations#change_password', as: :change_password, via: [:get,:put,:patch]
    match '/users/sign_out', to: 'sessions#destroy', as: :delete_user_session, via: [:get,:post,:put,:patch,:delete]
    get   '/register', to: 'registrations#new', as: :register
    get   '/login',    to: 'sessions#new',      as: :login
    match '/logout',   to: 'sessions#destroy',  as: :logout, via: [:get,:post,:put,:patch,:delete]
  end
  resources :authentications
  get '/invitation/:token', to: 'invitations#accept', as: :invitation

  get '/dashboard', to: 'dashboard#index', as: :dashboard

  get '/privacy', to: 'home#privacy', as: :privacy
  get '/terms',   to: 'home#terms',   as: :terms
  get '/about',   to: 'home#about',   as: :about
  get '/contact', to: 'home#contact', as: :contact
  get '/help',    to: 'home#help',    as: :help

  require 'subdomain'
  constraints(Subdomain) do
    # Change this action to serve subdomain-specific content as the root page,
    get '/', to: 'home#subdomain_specific_index'
  end

  ActiveAdmin.routes(self)

  root to: 'home#index'

  mount Sidekiq::Web, at: Rails.configuration.sidekiq.web.mount_point

  # Status check URL
  get 'ping' => proc {|env| [200, {}, ['pong']] }

  # Must be last in line
  # Catch unroutable paths and send to the routing error handler
  match '*a', to: 'home#routing_error', via: :all
end
