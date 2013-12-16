class User < ActiveRecord::Base
  attr_accessible :headline, :linkedin_location, :git_location, :current_location, :bio, :blog, :cohort_id, :email, :facebook_url, :github_url, :hacker_news_url, :hometown, :linkedin_url, :name, :quora, :twitter_url

  belongs_to :cohort
  has_many :authentications

  geocoded_by :current_location
  before_save :geocode
  # , :if => :key => "value", current_location_changed?

  def self.find_or_create_from_auth_hash(auth_hash)
    info = auth_hash['info']
    name = info['name'] || info['email']
    find_or_create_by_name(name)
  end

  def self.from_sf
    joins(:cohort).merge(Cohort.where(:location => "San Francisco"))
  end


  def self.from_chicago
    joins(:cohort).merge(Cohort.where(:location => "Chicago"))
  end

end
