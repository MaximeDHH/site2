Rails.application.routes.draw do
  root 'pages#home'
  get  '/contact', to: 'pages#contact'

  resources :bookings, only: [:new, :create]
  get  '/booking/success', to: 'bookings#success', as: :booking_success
  get  '/booking/cancel',  to: 'bookings#cancel',  as: :booking_cancel
  get  '/booking/slots',   to: 'bookings#slots',   as: :booking_slots
  post '/webhooks/stripe', to: 'bookings#webhook'

  get "up" => "rails/health#show", as: :rails_health_check
end
