class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart
  helper_method :current_user
  helper_method :current_admin?
  helper_method :current_merchant_employee?
  helper_method :current_merchant_admin?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_merchant_employee?
    current_user && current_user.merchant_employee?
  end

  def current_merchant_admin?
    current_user && current_user.merchant_admin?
  end

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

end
