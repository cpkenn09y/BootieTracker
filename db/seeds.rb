require "dbc-ruby"
DBC::token = ENV["DBC_TOKEN"]
require "URI"

start = Time.now
require "linkedin"

# linkedin_client = LinkedIn::Client.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])
# linkedin_client.authorize_from_access(ENV["ACCESS_KEY"], ENV["ACCESS_TOKEN"])

git_client = Octokit::Client.new :login => 'stephenitis', :password => 'codemore123'

p "seeding user data"
DBC::User.all.each do |user|
  if user.profile[:linked_in] && user.profile[:linked_in] != ""
    user.profile[:linked_in] = user.profile[:linked_in].slice(URI.regexp).gsub(/\/$/, "")
    p user.profile[:linked_in]
  else
    user.profile[:linked_in] = nil
  end
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
  if u.github_url
    begin
      gitname = u.github_url.slice(/[^\/]+$/)

      current_location_from_github = git_client.user(gitname).location
      p "github: #{current_location_from_github}"
      u.update_attributes(git_location: current_location_from_github)
    rescue => e
      p e
    end
  end
# if user.profile[:linked_in]
#   sleep 1
#     begin
#       linkedin_data = linkedin_client.profile(:url => user.profile[:linked_in], :fields => [ "location:(name)", "headline"] )

#       p "linkedin : #{linkedin_data[:location].name}"
#       u.update_attributes(:headline => linkedin_data[:headline] , :linkedin_location => linkedin_data[:location].name)
#     rescue => e
#       p e
#       u.update_attributes(:headline => nil, :linkedin_location => nil)
#     end
u.save
# end

end


p "seeding cohort data"
DBC::Cohort.all.each do |cohort|
  c = Cohort.create(c_id: cohort.id, cohort_name: cohort.name,  location: cohort.location)
  p cohort.name
  p c
end
p "done"




end_time = Time.now
total = end_time - start

p " this seed took #{total}"