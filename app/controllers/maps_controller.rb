class MapsController < ApplicationController
  respond_to :json, :html

  def index
    users = User.all
    @user_data = []
    users.each do |user|
      @user_data << { :user => {
        name: user.name,
        email: user.email,
        cohort_name: user.cohort,
        linked_in: user.linked_in_url,
        facebook: user.facebook_url,
        twitter: user.twitter_url,
        github: user.github_url,
        blog: user.blog,
        role: user.role,
        headline: user.headline,
        current_location: user.current_location,
        latitude: user.latitude,
        longitude: user.longitude}}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_data}
    end
  end

end