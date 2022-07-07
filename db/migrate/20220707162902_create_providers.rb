class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name
      t.text :bio
      t.decimal :cost
      t.string :image

      t.timestamps
    end
  end
end
