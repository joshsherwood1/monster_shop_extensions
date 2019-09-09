class MerchantUser <ApplicationRecord
  validates_presence_of :merchant_id, :user_id

  belongs_to :merchant
  belongs_to :user

end
