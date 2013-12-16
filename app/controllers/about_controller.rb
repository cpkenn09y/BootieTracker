class AboutController < ApplicationController
  def index
    if session[:user_id]
      @user = current_user
    end
  end
end