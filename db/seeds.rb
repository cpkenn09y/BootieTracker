require "dbc-ruby"
DBC::token = "abf152a100244d8a1c9765282ebd9b0a"

DBC::User.all.each do |user|
  u= User.create(
    :name => user.name,
    :email => user.email,
    :cohort_id => user.cohort_id,
    :hometown => user.profile["hometown"],
    :linked_in_url => user.profile["linked_in"],
    :facebook_url => user.profile["facebook"],
    :twitter_url => user.profile["twitter"],
    :github_url => user.profile["github"],
    :blog => user.profile["blog"],
    :quora => user.profile["quora"],
    :hacker_news_url => user.profile["hacker_news"]
    # :role => user.roles
  )
  p u
end

p "done bitches"