class User < ActiveRecord::Base
  attr_accessible :headline, :location_name, :current_location, :bio, :blog, :cohort_id, :email, :facebook_url, :github_url, :hacker_news_url, :hometown, :linked_in_url, :name, :quora, :twitter_url

  before_save :update_location

  belongs_to :cohort

  def update_location

  end

end
