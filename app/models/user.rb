class User < ActiveRecord::Base
<<<<<<< Updated upstream
  attr_accessible :headline, :location_name, :current_location, :bio, :blog, :cohort_id, :email, :facebook_url, :github_url, :hacker_news_url, :hometown, :linked_in_url, :name, :quora, :twitter_url

  before_save :update_location


  def update_location

  end

end
=======
  attr_accessible :first_name, :last_name, :location

end
>>>>>>> Stashed changes
