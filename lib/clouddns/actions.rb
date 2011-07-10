
require 'clouddns/actions/generic_action'
require 'clouddns/actions/print'

module Clouddns
  module Actions
    def self.by_name name
      case name.downcase
      when 'print' then Print
      end
    end
  end
end

