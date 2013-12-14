require "dbc-ruby"
# DBC::token = "abf152a100244d8a1c9765282ebd9b0a"
DBC::token = ENV["DBC_TOKEN"]

require "linkedin"

# client = LinkedIn::Client.new('757qtxz1q0v0ue', 'DZyO7waOaS4KEvKl')
client = LinkedIn::Client.new(ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"])
# rtoken = client.request_token.token
# rsecret = client.request_token.secret
# client.authorize_from_request(rtoken, rsecret, 33109)

client.authorize_from_access(ENV["ACCESS_KEY"], ENV["ACCESS_TOKEN"])

DBC::User.all.each do |user|
  # case user.profile[:linked_in]
  # when ""
  #   user.profile[:linked_in] == nil
  # when
  #   nil
  # else
  #   cleaned_url = user.profile[:linked_in].gsub(/\/$/, "")
  #   p cleaned_url
  # end
  u= User.create(
    :name => user.name,
    :email => user.email,
    :cohort_id => user.cohort_id,
    :hometown => user.profile[:hometown],
    # :linked_in_url => cleaned_url,
    :facebook_url => user.profile[:facebook],
    :twitter_url => user.profile[:twitter],
    :github_url => user.profile[:github],
    :blog => user.profile[:blog],
    :quora => user.profile[:quora],
    :hacker_news_url => user.profile[:hacker_news],
    :current_location => user.profile[:current_location]
    )

  # if (u.linked_in_url != nil)
  #   if u.linked_in_url.match(/http:\/\/linkedin.com\/in/) || u.linked_in_url.match(/http:\/\/linkedin.com\/pub/)
  #     p "i'm here"
  #     begin
  #       linkedin_data = client.profile(:url => cleaned_url, :fields => [ "location:(name)", "first-name", "last-name", "headline"] )
  #       p "printing linked in data"
  #       p linkedin_data[:headline]
  #       p linkedin_data[:location].name

  #       u.update_attributes(:headline => linkedin_data[:headline] , :location_name => linkedin_data[:location])
  #     rescue
  #       p "NOT FOUND"
  #     end

  #   end
  # else
  #   u.update_attributes(:headline => "UNKNOWN" , :location_name => "UNKNOWN")
  # end

end

p "done"