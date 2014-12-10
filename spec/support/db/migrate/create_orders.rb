class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.string :isbn
      t.string :manager

      t.timestamps
    end
  end
end
