class Admin::BookingsController < AdminController
  def index
    @bookings = Booking.order(date: :asc, time_slot: :asc)
    @bookings = @bookings.where(status: params[:status]) if params[:status].present?
    @bookings = @bookings.where(date: Date.parse(params[:date])) if params[:date].present?

    @counts = {
      total:     Booking.count,
      pending:   Booking.where(status: 'pending').count,
      confirmed: Booking.where(status: 'confirmed').count,
      cancelled: Booking.where(status: 'cancelled').count
    }
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def confirm
    @booking = Booking.find(params[:id])
    @booking.update!(status: 'confirmed')
    BookingMailer.confirmation(@booking).deliver_later
    SmsService.send_booking_confirmed(@booking)
    redirect_to admin_bookings_path, notice: "Réservation ##{@booking.id} confirmée."
  end

  def cancel
    @booking = Booking.find(params[:id])
    @booking.update!(status: 'cancelled')
    BookingMailer.cancellation(@booking).deliver_later
    SmsService.send_booking_cancelled(@booking)
    redirect_to admin_bookings_path, notice: "Réservation ##{@booking.id} annulée."
  end
end
