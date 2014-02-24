def initialize_git_client
  @git_client =  Octokit::Client.new :access_token => ENV["GITHUB_ACCESS_TOKEN"]
end

def check_and_update_github_url(user)
  if user.github_url || user.github_url == ""
    begin
      gitname = user.github_url.slice(/[^\/]+$/)
      current_location_from_github = @git_client.user(gitname).location
      if current_location_from_github
        longitude_before = user.longitude
        user.update_attributes(git_location: current_location_from_github)
        if longitude_before == user.longitude
          p "longitude was the same #{longitude_before} == #{user.longitude}"
        else
          @updated_users << user
          p "longitude changed from #{longitude_before} to #{user.longitude}"
        end
      else
        p "no location form github url they sux"
      end
    rescue => e
      p e
    end
  end
end

namespace :update do
  desc "UPDATE_GITHUB"
  task :github => :environment do
    start = Time.now

    count = User.where("longitude is NOT NULL").count
    p "there are currently #{count} users with location coordinates"

    initialize_git_client

    @updated_users = []
    User.where("GITHUB_URL IS NOT NULL").each do |user|
      p "checking user #{user.name}"
      check_and_update_github_url(user)
    end

    end_time = Time.now
    total = end_time - start
    p " this seed took #{total}"

    p "#{@updated_users.count} users where updated"

    count = User.where("longitude is NOT NULL").count
    p "there are currently #{count} users with location coordinates"




  end
end
