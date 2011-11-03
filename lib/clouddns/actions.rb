
require 'clouddns/actions/generic_action'
require 'clouddns/actions/print'
require 'clouddns/actions/migrate'
require 'clouddns/actions/zonefile'

module Clouddns
  module Actions
    def self.by_name name
      case name.downcase
      when 'print' then Print
      when 'migrate' then Migrate
      when 'zonefile' then Zonefile
      else
        raise "Unknown action: #{name}"
      end
    end
  end
end

