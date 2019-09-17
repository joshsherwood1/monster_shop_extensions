require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it {should validate_presence_of(:name)}
    # it {should validate_presence_of :percent_off , :unless => :amount_off}
    # it {should validate_presence_of :amount_off , :unless => :percent_off}
    it {should validate_presence_of(:enabled?)}

    context "if coupon is a dollar amount off" do
      before { allow(subject).to receive(:percent_off).and_return(nil) }
      it { should validate_presence_of(:amount_off) }
    end

    context "if coupon is a percentage off" do
      before { allow(subject).to receive(:amount_off).and_return(nil) }
      it { should validate_presence_of(:percent_off) }
    end
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end
