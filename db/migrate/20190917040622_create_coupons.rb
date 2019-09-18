class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.float :percent_off
      t.float :amount_off
      t.boolean :enabled?, default: true
    end
  end
end
