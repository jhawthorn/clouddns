
module Clouddns
  class Zone
    attr_accessor :name, :records
    def initialize name
      @name = name
      @records = []
    end
  end
end

