class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.string :name,             null: false
      t.string :email,            null: false
      t.string :phone
      t.string :service,          null: false
      t.date   :date,             null: false
      t.string :time_slot,        null: false
      t.string :status,           null: false, default: 'pending'
      t.string :stripe_session_id

      t.index [:date, :time_slot]

      t.timestamps
    end
  end
end
