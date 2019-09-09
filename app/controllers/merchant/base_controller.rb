class Merchant::BaseController < ApplicationController
  before_action :require_merchant

  def require_merchant
    render file: "/public/404" unless current_merchant_admin? || current_merchant_employee?
  end
end
