class CreateMerchantUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :merchant_users do |t|
      t.references :merchant, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
