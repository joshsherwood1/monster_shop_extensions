class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address_type, default: 'home'
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
    end
  end
end
