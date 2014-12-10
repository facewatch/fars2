class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email
      t.string :name
      t.string :city
      t.string :street_name
      t.string :building_number
      t.string :zip_code
      t.string :credit_card_number
      t.string :credit_card_expiry_date
      t.string :credit_card_type

      t.timestamps
    end
  end
end
