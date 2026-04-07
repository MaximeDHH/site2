class BookingsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)

    unless @booking.valid?
      render :new, status: :unprocessable_entity and return
    end

    @booking.save!

    checkout_session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: {
            name: @booking.service,
            description: "#{@booking.date.strftime('%d/%m/%Y')} à #{@booking.time_slot}"
          },
          unit_amount: @booking.price_cents
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: booking_success_url(session_id: '{CHECKOUT_SESSION_ID}'),
      cancel_url:  booking_cancel_url(id: @booking.id),
      customer_email: @booking.email,
      metadata: { booking_id: @booking.id }
    )

    @booking.update!(stripe_session_id: checkout_session.id)
    redirect_to checkout_session.url, allow_other_host: true
  end

  def success
    session  = Stripe::Checkout::Session.retrieve(params[:session_id])
    @booking = Booking.find_by(stripe_session_id: session.id)
    @booking&.update!(status: 'confirmed')
  end

  def cancel
    @booking = Booking.find(params[:id])
    @booking.update!(status: 'cancelled')
  end

  def slots
    date         = Date.parse(params[:date])
    taken        = Booking.where(date: date, status: %w[pending confirmed]).pluck(:time_slot)
    available    = Booking::TIME_SLOTS - taken
    render json: { available: available }
  rescue ArgumentError
    render json: { available: Booking::TIME_SLOTS }
  end

  def webhook
    payload    = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET'])
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      head :bad_request and return
    end

    if event['type'] == 'checkout.session.completed'
      session  = event['data']['object']
      booking  = Booking.find_by(stripe_session_id: session['id'])
      booking&.update!(status: 'confirmed')
    end

    head :ok
  end

  private

  def booking_params
    params.require(:booking).permit(:name, :email, :phone, :service, :date, :time_slot)
  end
end
