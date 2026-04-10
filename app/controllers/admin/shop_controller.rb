class Admin::ShopController < AdminController
  FLAG = Rails.root.join('tmp', 'shop_closed.json')

  def self.closure
    return nil unless FLAG.exist?
    data = JSON.parse(FLAG.read) rescue nil
    return nil unless data
    { from: Date.parse(data['from']), to: Date.parse(data['to']) }
  rescue
    nil
  end

  def show
    @closure = self.class.closure
  end

  def update
    from = Date.parse(params[:from])
    to   = Date.parse(params[:to])

    if to < from
      redirect_to admin_shop_path, alert: "La date de fin doit être après la date de début."
      return
    end

    FLAG.write(JSON.generate(from: from.iso8601, to: to.iso8601))
    redirect_to admin_shop_path, notice: "Fermeture programmée du #{I18n.l(from, format: :long)} au #{I18n.l(to, format: :long)}."
  end

  def cancel
    FLAG.delete if FLAG.exist?
    redirect_to admin_shop_path, notice: "La fermeture a été annulée — le salon est de nouveau ouvert."
  end
end
