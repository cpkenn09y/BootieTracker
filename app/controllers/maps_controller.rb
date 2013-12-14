class MapsController < ApplicationController
  respond_to :json, :html

  def index
    if session[:user_id]
      p "there is a USER!"
      @user= User.find(session[:user_id])
    end
    users = User.all
    p "????"
    p users.count
    @user_data = []
    users.each do |user|
      gravatar_url = Gravatar.new(user.email).image_url
      p gravatar_url
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
        latitude: user.latitude,
        longitude: user.longitude,
        }}
    end

    respond_to do |format|
      format.html
      format.json { render :json => @user_data}
    end
  end

end