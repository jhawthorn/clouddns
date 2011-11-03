
require 'clouddns'
require 'pathname'

namespace :dns do
  desc "Print DNS entries from config/dns/*.rb"
  task :print do
    run_action Clouddns::Actions::Print
  end
  desc "Update DNS service with config/dns/*.rb"
  task :migrate do
    run_action Clouddns::Actions::Migrate
  end
  desc "Print config/dns/*.rb as zonefiles"
  task :zonefile do
    run_action Clouddns::Actions::Zonefile
  end
  def run_action action
    root_path = defined?(Rails) ? Rails.root : Pathname.new('.')
    dns_path = root_path.join('config', 'dns')
    files = Dir[dns_path.join('**','*.rb')]
    if files.empty?
      raise "No DNS configuration. Please create config/dns/yourdomain.rb"
    end
    files.each do |file|
      dsl = Clouddns::DSL.parse_file(file)
      dsl.zones.each do |zone|
        action.run(zone)
      end
    end
  end
end

