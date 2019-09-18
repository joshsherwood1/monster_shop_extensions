class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates_presence_of :percent_off, :unless => :amount_off
  validates_presence_of :amount_off, :unless => :percent_off
  validates :enabled?, presence: true
  validates_numericality_of :amount_off, greater_than: 0, :unless => :percent_off
  validates_numericality_of :percent_off, greater_than: 0, less_than: 100, :unless => :amount_off

  # def toggle_off
  #   #binding.pry
  #   self.update(enabled?: !enabled?)
  #   self.save
  #   #binding.pry
  # end

end
