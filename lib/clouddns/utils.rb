module Clouddns
  module Utils
    extend self

    def parse_domain name
      if name =~ /\A(.*?\..*?)\.?\z/
        "#{$1}."
      else
        raise "Invalid domain: '#{name}'"
      end
    end
  end
end
