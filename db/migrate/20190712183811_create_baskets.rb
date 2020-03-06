class CreateBaskets < ActiveRecord::Migration[5.2]
  def change
    create_table :baskets do |t|
      t.string :name
      t.text :payment_data
      t.timestamps
    end
  end
end
