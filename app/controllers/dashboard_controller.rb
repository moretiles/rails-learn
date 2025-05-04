class DashboardController < ApplicationController
  def index
    if Current.user.nil?
      redirect_to "products#index"
    else
      @email = Current.user.email_address
    end
  end
end
