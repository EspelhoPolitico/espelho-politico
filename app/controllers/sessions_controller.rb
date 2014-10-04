class SessionsController < ApplicationController

  def new
  end

  def sign_up
  end

  def sign_in
    user = User.find_by_username(params[:user][:username])
  if user && user.authenticate(params[:user][:password])
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Logged in!"
    else
      flash[:alert] = "Invalid username or password"
      redirect_to root_url
    end
  end

  def sign_out
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end