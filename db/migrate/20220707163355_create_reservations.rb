class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.decimal :total_cost

      t.timestamps
    end
  end
end
