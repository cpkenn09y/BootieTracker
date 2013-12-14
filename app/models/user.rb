class User < ActiveRecord::Base
  attr_accessible :headline, :location_name, :current_location, :bio, :blog, :cohort_id, :email, :facebook_url, :github_url, :hacker_news_url, :hometown, :linked_in_url, :name, :quora, :twitter_url

  belongs_to :cohort

  geocoded_by :current_location
  before_save :geocode, :if => :current_location_changed?


  def self.from_sf
    joins(:cohort).merge(Cohort.where(:location => "San Francisco"))
  end


  def self.from_chicago
    joins(:cohort).merge(Cohort.where(:location => "Chicago"))
  end

end
