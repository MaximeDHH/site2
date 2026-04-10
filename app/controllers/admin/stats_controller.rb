class Admin::StatsController < AdminController
  def index
    confirmed = Booking.where(status: 'confirmed')
    now       = Date.today

    @ca_total  = confirmed.sum(&:price_cents) / 100.0
    @ca_month  = confirmed.select { |b| b.date.year == now.year && b.date.month == now.month }
                          .sum(&:price_cents) / 100.0
    @ca_week   = confirmed.select { |b| b.date >= now.beginning_of_week }
                          .sum(&:price_cents) / 100.0

    total = Booking.count.to_f
    @taux_confirmation = total > 0 ? (confirmed.count / total * 100).round(1) : 0

    @next_booking = Booking.where(status: %w[pending confirmed])
                           .where('date >= ?', now)
                           .order(:date, :time_slot)
                           .first

    # Top 5 services (confirmés)
    @top_services = confirmed.group_by(&:service)
                             .transform_values(&:count)
                             .sort_by { |_, v| -v }
                             .first(5)

    # Réservations des 6 derniers mois
    @monthly = (5.downto(0)).map do |i|
      date  = now - i.months
      month = date.beginning_of_month
      label = I18n.l(month, format: '%b %Y')
      count = Booking.where(date: month..month.end_of_month).count
      ca    = confirmed.select { |b| b.date >= month && b.date <= month.end_of_month }
                       .sum(&:price_cents) / 100.0
      { label: label, count: count, ca: ca }
    end
  end
end
