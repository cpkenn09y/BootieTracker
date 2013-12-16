class MapsController < ApplicationController
  respond_to :json, :html
  def index
    if session[:user_id]
      @user= User.find(session[:user_id])
    end
    users = User.all
    @user_data = []
    create_user_data_json(users)

    respond_to do |format|
      format.html
      format.json { render :json => @user_data}
      end
    end
  end

private
  def create_user_data_json(users)
    users.each do |user|
      gravatar_url = Gravatar.new(user.email).image_url
      @user_data << { :user => {
      name: user.name,
      image_url: gravatar_url,
      email: user.email,
      cohort_name: user.cohort,
      linked_in: user.linkedin_url,
      facebook: user.facebook_url,
      twitter: user.twitter_url,
      github: user.github_url,
      blog: user.blog,
      role: user.role,
      headline: user.headline,
      current_location: user.current_location,
      git_location: user.git_location,
      latitude: user.latitude,
      longitude: user.longitude,
    }}
  end

end