
module Clouddns
  class Record
    attr_accessor :attributes
    alias :to_hash :attributes

    def initialize type, name, value, options = {}
      value = [value] unless value.is_a? Array
      options[:ttl] ||= 600

      self.attributes = options.merge({
        :type => type,
        :name => name,
        :value => value
      })
    end

    def name;  attributes[:name]; end
    def value; attributes[:value]; end
    def type;  attributes[:type]; end
    def ttl;   attributes[:ttl]; end
  end
end

