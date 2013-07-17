require 'thor'

module Clouddns
  module Actions
    class GenericAction < Thor::Shell::Basic
      def initialize zone, options = {}
        @zone = zone
        @options = options
        super()
      end
      def self.run zone, options = {}
        new(zone, options).run
      end
    end
  end
end
