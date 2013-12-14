class MapsController < ApplicationController
  respond_to :json, :html

  def index
    users = User.all
    p "????"
    p users.count
    @user_data = []
    users.each do |user|
      @user_data << { :user_name => {
        name: user.name,
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
        longitude: user.longitude}}
    end

# =======
#     @users = User.all
#     @all_locations = []
#     @users.each {|user| @all_locations << user.current_location }
#     puts @all_locations
# >>>>>>> Stashed changes
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_data}
    end
  end

end