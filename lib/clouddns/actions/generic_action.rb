module Clouddns
  module Actions
    class GenericAction
      def initialize zone, options = {}
        @zone = zone
        @options = options
      end
      def self.run zone, options = {}
        new(zone, options).run
      end
    end
  end
end
