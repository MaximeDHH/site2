class SmsService
  def self.send_booking_confirmed(booking)
    send_sms(
      to:   booking.phone,
      body: "Royal Nail — Réservation confirmée ✓\n" \
            "#{booking.service}\n" \
            "#{booking.date.strftime('%A %d %B')} à #{booking.time_slot}\n" \
            "À bientôt ! 06 27 35 81 88"
    )
  end

  def self.send_booking_cancelled(booking)
    send_sms(
      to:   booking.phone,
      body: "Royal Nail — Votre rendez-vous du #{booking.date.strftime('%d/%m')} à #{booking.time_slot} " \
            "a été annulé. Contactez-nous au 06 27 35 81 88."
    )
  end

  private

  def self.send_sms(to:, body:)
    return if to.blank?
    return unless twilio_configured?

    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    client.messages.create(
      from: ENV['TWILIO_FROM_NUMBER'],
      to:   format_phone(to),
      body: body
    )
  rescue Twilio::REST::TwilioError => e
    Rails.logger.error "SMS error for booking: #{e.message}"
  end

  def self.twilio_configured?
    ENV['TWILIO_ACCOUNT_SID'].present? &&
      !ENV['TWILIO_ACCOUNT_SID'].start_with?('AC_REMPLACE')
  end

  def self.format_phone(number)
    # Convertit 06 27 35 81 88 → +33627358188
    digits = number.gsub(/\D/, '')
    return "+#{digits}" if digits.start_with?('33')
    digits.start_with?('0') ? "+33#{digits[1..]}" : "+33#{digits}"
  end
end
