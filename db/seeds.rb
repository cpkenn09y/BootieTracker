require "dbc-ruby"
DBC::token = ENV["DBC_TOKEN"]
require "URI"

start = Time.now
User.delete_all
# require "linkedin"
# @linkedin_client = LinkedIn::Client.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])
# THIS DONT WORK BECAUSE OAUTH TOKEN WILL EXPIRE AND CURRENTLY IS EXPIRED
# @linkedin_client.authorize_from_access(ENV["ACCESS_KEY"], ENV["ACCESS_TOKEN"])

@git_client = Octokit::Client.new :login => ENV["GIT_USER"], :password => ENV['PASSWORD']

p "seeding user data"
DBC::User.all.each do |user|

  if user.profile[:linked_in] && user.profile[:linked_in] != ""
    user.profile[:linked_in] = user.profile[:linked_in].slice(URI.regexp).gsub(/\/$/, "")
    
  else
    user.profile[:linked_in] = nil
  end

  p user.profile[:current_location]

  u = User.create(
    :name => user.name,
    :email => user.email,
    :cohort_id => user.cohort_id,
    :hometown => user.profile[:hometown],
    :linkedin_url => user.profile[:linked_in],
    :facebook_url => user.profile[:facebook],
    :twitter_url => user.profile[:twitter],
    :github_url => user.profile[:github],
    :blog => user.profile[:blog],
    :current_location => user.profile[:current_location]
    )

  # check_and_update_linkedin(user.profile[:linked_in])
end


# def check_and_update_linkedin(linked_in_url)
#   if linked_in_url
#   sleep 1
#     begin
#       linkedin_data = @linkedin_client.profile(:url => linked_in_url, :fields => [ "location:(name)", "headline"] )

#       p "linkedin : #{linkedin_data[:location].name}"
#       # u.update_attributes(:headline => linkedin_data[:headline] , :linkedin_location => linkedin_data[:location].name)
#     rescue => e
#       p e
#       p "bad url"
#       # u.update_attributes(:headline => nil, :linkedin_location => nil)
#     end
#   end
# end
  # if u.github_url
  #   begin
  #     gitname = u.github_url.slice(/[^\/]+$/)

  #     current_location_from_github = git_client.user(gitname).location
  #     p "github: #{current_location_from_github}"
  #     u.update_attributes(git_location: current_location_from_github)
  #   rescue => e
  #     p e
  #   end
  # end


# end

# def check_and_update_github_url(github_url)
#     if github_url
#     begin
#       gitname = github_url.slice(/[^\/]+$/)
#       current_location_from_github = @git_client.user(gitname).location
#       p "github: #{current_location_from_github}"
#       # u.update_attributes(git_location: current_location_from_github)
#     rescue => e
#       p e
#     end
#   end
# end

p "seeding cohort data"
DBC::Cohort.all.each do |cohort|
  if cohort.name.match(/(Melt|On\sHold)/)
    p "not adding cohort #{cohort.name}"
  else
    c = Cohort.create(c_id: cohort.id, cohort_name: cohort.name,  location: cohort.location)
    p "adding cohort #{cohort.name}"
end
end
p "DONE"


end_time = Time.now
total = end_time - start

p "remove users with no cohort"
User.all.each {|u| u.destroy if u.cohort == nil}

p " this seed took #{total}"

count = User.where("longitude is NOT NULL").count
p "there are currently #{count} users with location coordinates"

count = User.where("current_location is NOT NULL").count
p "there are currently #{count} users with current_locations"

count = User.where("github_url is NOT NULL").count
p "there are currently #{count} users with github urls"


# " this seed took 119.478377"
# "there are currently 456 users with location coordinates"
# "there are currently 537 users with current_locations"
# "there are currently 754 users with github urls"
