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

    def format_record record, options={}
      namelength = options[:namelength] || 20
      prefix = options[:prefix] || ''

      output = []

      record.value.each_with_index do |value, i|
        if i.zero?
          args = [prefix, record.type, record.ttl, record.name, value]
        else
          args = [prefix, '', '', '', value]
        end
        output << "%s%5s %5s %#{namelength}s %s" % args
      end

      output.join("\n")
    end
  end
end
