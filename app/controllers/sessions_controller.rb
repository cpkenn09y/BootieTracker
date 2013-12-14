class SessionsController < ApplicationController
  require "pry"
  def sign_in
   redirect to ('/auth/dbc')
  end

  def destroy
    session.clear
    redirect_to root_url
  end

  def create
    p params
    p session
    auth = Authentication.find_or_create_from_auth_hash(auth_hash)
    @user =  User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to '/'
  end

protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
