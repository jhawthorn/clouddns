
require 'clouddns/actions/generic_action'
require 'clouddns/actions/print'
require 'clouddns/actions/migrate'

module Clouddns
  module Actions
    def self.by_name name
      case name.downcase
      when 'print' then Print
      when 'migrate' then Migrate
      else
        raise "Unknown action: #{name}"
      end
    end
  end
end

