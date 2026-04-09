class Booking < ApplicationRecord
  SERVICES = {
    # Manucure
    'Manucure'                                              => 1500,
    'Manucure & Vernis coloré'                              => 2000,
    'Manucure & Vernis French'                              => 2500,
    'Manucure & Vernis semi-permanent coloré'               => 4000,
    'Manucure & Vernis semi-permanent French'               => 4500,
    'Pose de vernis coloré'                                 => 1000,
    'Pose de vernis French'                                 => 1500,
    'Pose de vernis semi-permanent coloré'                  => 3000,
    'Pose de vernis semi-permanent French'                  => 3500,
    'Pose de faux ongles en résine'                         => 2500,
    'Pose de capsules en résine & Vernis coloré'            => 3200,
    'Pose complète résine & Vernis semi-permanent'          => 4200,
    'Pose de faux ongles en gel'                            => 4000,
    'Pose de faux ongles en gel & Vernis coloré'            => 5000,
    'Pose de faux ongles en gel & Vernis semi-permanent'    => 6000,
    'Remplissage résine & Vernis coloré'                    => 2800,
    'Remplissage résine & Vernis semi-permanent'            => 3800,
    'Remplissage gel & Vernis coloré'                       => 4500,
    'Beauté des mains & pieds — Vernis coloré'             => 5000,
    'Beauté des mains & pieds — Vernis semi-permanent'     => 8000,
    # Beauté des pieds
    'Beauté des pieds'                                      => 3000,
    'Beauté des pieds & Vernis coloré'                      => 3500,
    'Beauté des pieds & Vernis French'                      => 4000,
    'Beauté des pieds & Vernis semi-permanent'              => 4500,
    'Beauté des pieds & Vernis semi-permanent French'       => 5000,
    'Pose de vernis coloré sur les pieds'                   => 1500,
    'Pose de vernis French sur les pieds'                   => 2000,
    'Pose de vernis semi-permanent coloré sur les pieds'    => 3000,
    'Pose de vernis semi-permanent French sur les pieds'    => 3500,
    # Épilation
    'Épilation aisselles'                                   =>  1000,
    'Épilation demi-bras'                                   =>  1500,
    'Épilation bras entiers'                                =>  2500,
    'Épilation demi-jambes'                                 =>  1500,
    'Épilation jambes entières'                             =>  3000,
    'Épilation maillot simple'                              =>  1500,
    'Épilation maillot intégral'                            =>  3000,
    'Épilation fesses'                                      =>  1200,
    'Pack demi-jambes + aisselles + maillot intégral'       =>  5000,
    'Pack jambes entières + aisselles + maillot simple'     =>  5000,
  }.freeze

  MANUCURE_KEYS = [
    'Manucure', 'Manucure & Vernis coloré', 'Manucure & Vernis French',
    'Manucure & Vernis semi-permanent coloré', 'Manucure & Vernis semi-permanent French',
    'Pose de vernis coloré', 'Pose de vernis French',
    'Pose de vernis semi-permanent coloré', 'Pose de vernis semi-permanent French',
    'Pose de faux ongles en résine', 'Pose de capsules en résine & Vernis coloré',
    'Pose complète résine & Vernis semi-permanent', 'Pose de faux ongles en gel',
    'Pose de faux ongles en gel & Vernis coloré', 'Pose de faux ongles en gel & Vernis semi-permanent',
    'Remplissage résine & Vernis coloré', 'Remplissage résine & Vernis semi-permanent',
    'Remplissage gel & Vernis coloré',
    'Beauté des mains & pieds — Vernis coloré', 'Beauté des mains & pieds — Vernis semi-permanent',
  ].freeze

  PIEDS_KEYS = [
    'Beauté des pieds', 'Beauté des pieds & Vernis coloré', 'Beauté des pieds & Vernis French',
    'Beauté des pieds & Vernis semi-permanent', 'Beauté des pieds & Vernis semi-permanent French',
    'Pose de vernis coloré sur les pieds', 'Pose de vernis French sur les pieds',
    'Pose de vernis semi-permanent coloré sur les pieds', 'Pose de vernis semi-permanent French sur les pieds',
  ].freeze

  EPILATION_KEYS = [
    'Épilation aisselles', 'Épilation demi-bras', 'Épilation bras entiers',
    'Épilation demi-jambes', 'Épilation jambes entières', 'Épilation maillot simple',
    'Épilation maillot intégral', 'Épilation fesses',
    'Pack demi-jambes + aisselles + maillot intégral',
    'Pack jambes entières + aisselles + maillot simple',
  ].freeze

  SERVICES_BY_CATEGORY = {
    'Manucure'        => SERVICES.slice(*MANUCURE_KEYS),
    'Beauté des pieds' => SERVICES.slice(*PIEDS_KEYS),
    'Épilation'        => SERVICES.slice(*EPILATION_KEYS),
  }.freeze

  TIME_SLOTS = %w[10:00 11:00 12:00 14:00 15:00 16:00 17:00 18:00 19:00].freeze

  validates :name, :email, :service, :date, :time_slot, presence: true
  validates :service, inclusion: { in: SERVICES.keys }
  validates :time_slot, inclusion: { in: TIME_SLOTS }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate  :date_must_be_in_future
  validate  :slot_must_be_available

  def price_cents
    SERVICES[service] || 0
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
