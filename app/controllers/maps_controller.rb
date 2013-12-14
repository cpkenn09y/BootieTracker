class MapsController < ApplicationController
  respond_to :json, :html

  def index
    @users = User.all
    @all_locations = []
    @users.each {|user| @all_locations << user.location }
    puts @all_locations
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @all_locations}
    end
  end

end