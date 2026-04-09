class BookingMailer < ApplicationMailer
  def confirmation(booking)
    @booking = booking
    mail(
      to:      booking.email,
      subject: "Votre réservation chez Royal Nail est confirmée ✓"
    )
  end

  def cancellation(booking)
    @booking = booking
    mail(
      to:      booking.email,
      subject: "Votre réservation chez Royal Nail a été annulée"
    )
  end
end
