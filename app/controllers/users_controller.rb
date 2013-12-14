class UsersController < ApplicationController
  def index
  end

  def edit
   @user = current_user
  end

  def update
   @user = current_user
   if @user.update_attributes(params[:user])
    @message = "Your data has been updated! Make sure you keep your online profiles up to date as we will poll your profiles bi monthly!"
  else
    @message = "SOMETHING WENT WRONG"
  end
    p @message
   # render(:edit)
  end
end