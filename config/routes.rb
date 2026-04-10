Rails.application.routes.draw do
  root 'pages#home'
  get  '/contact', to: 'pages#contact'

  resources :bookings, only: [:new, :create]
  get  '/booking/success', to: 'bookings#success', as: :booking_success
  get  '/booking/cancel',  to: 'bookings#cancel',  as: :booking_cancel
  get  '/booking/slots',   to: 'bookings#slots',   as: :booking_slots
  post '/webhooks/stripe', to: 'bookings#webhook'

  namespace :admin do
    root 'bookings#index'
    get  '/stats', to: 'stats#index', as: :stats
    get  '/shop',        to: 'shop#show',   as: :shop
    patch '/shop',       to: 'shop#update'
    post '/shop/cancel', to: 'shop#cancel', as: :shop_cancel
    resources :bookings, only: [:index, :show] do
      member do
        patch :confirm
        patch :cancel
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
