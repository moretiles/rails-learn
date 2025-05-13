class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def index
  end

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    logger.debug(params)
    if params[:id].nil?
      terminate_session
      redirect_to root_path
    else
      target = Session.find(params[:id])
      target.destroy if target.user_id == Current.user.id
      redirect_back_or_to "sessions#index"
    end
  end
end
