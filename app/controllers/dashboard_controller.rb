class DashboardController < ApplicationController
  def index
    if authenticated?
      @email = Current.user.email_address
    else
      redirect_to "products#index"
    end
  end
end
