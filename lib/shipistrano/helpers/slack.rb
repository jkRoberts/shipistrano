## slack notification requires:
# set :slack_channel
# set :slack_team
# set :slack_token
# set :stage, "production"

class ShipistranoSlack
  require 'net/http'

  def self.post_to_slack(slack_team, slack_token, slack_channel, message)
    if not slack_token.nil?
      uri = URI(URI.encode("https://#{slack_team}.slack.com/services/hooks/slackbot?token=#{slack_token}&channel=##{slack_channel}"))

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request_post uri.request_uri, message
      end
    end
  end

end

namespace :slack do
  task :prenotify do
    if fetch(:slack_token, false) then
      user = `whoami`.chomp.split(".").map(&:capitalize).join(' ')
      message = "#{user} is deploying #{app} to #{stage}"

      ShipistranoSlack.post_to_slack(slack_team, slack_token, slack_channel, message)
    end
  end

  task :postnotify do
    if fetch(:slack_token, false) then
      user = `whoami`.chomp.split(".").map(&:capitalize).join(' ')
      revision = `cat #{local_cache}/REVISION`.chomp
      message = "#{user} has deployed #{app} version #{revision} to #{stage}"

      ShipistranoSlack.post_to_slack(slack_team, slack_token, slack_channel, message)
    end
  end
end

# wait till hash is changed.
before 'deploy:update_code', 'slack:prenotify'
after 'deploy:update', 'slack:postnotify'
