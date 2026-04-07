class Booking < ApplicationRecord
  SERVICES = {
    'Manucure classique' => 2500,
    'Pose en gel'        => 4500,
    'Nail art'           => 5500,
    'Soin des mains'     => 3500
  }.freeze

  TIME_SLOTS = %w[10:00 11:00 12:00 14:00 15:00 16:00 17:00 18:00 19:00].freeze

  validates :name, :email, :service, :date, :time_slot, presence: true
  validates :service, inclusion: { in: SERVICES.keys }
  validates :time_slot, inclusion: { in: TIME_SLOTS }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate  :date_must_be_in_future
  validate  :slot_must_be_available

  def price_cents
    SERVICES[service]
  end

  def price_euros
    price_cents / 100.0
  end

  def taken_slots_on(date)
    Booking.where(date: date, status: %w[pending confirmed])
           .where.not(id: id)
           .pluck(:time_slot)
  end

  private

  def date_must_be_in_future
    errors.add(:date, 'doit être dans le futur') if date.present? && date < Date.today
  end

  def slot_must_be_available
    return unless date.present? && time_slot.present?

    taken = Booking.where(date: date, time_slot: time_slot, status: %w[pending confirmed])
                   .where.not(id: id)
                   .exists?
    errors.add(:time_slot, 'ce créneau est déjà réservé') if taken
  end
end
