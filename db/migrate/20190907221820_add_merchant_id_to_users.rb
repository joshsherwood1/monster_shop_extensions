class AddMerchantIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :merchant_id, :integer, default: nil
  end
end
