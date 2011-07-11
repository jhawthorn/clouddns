module Clouddns
  module Actions
    module PrintRecord
      protected
      def print_record record, namelength, prefix=''
        values = record.respond_to?(:value) ? record.value : record.ip
        values.each_with_index do |value, i|
          if i.zero?
            args = [prefix, record.type, record.ttl, record.name, value]
          else
            args = [prefix, '', '', '', value]
          end
          puts "%s%5s %5s %#{namelength}s %s" % args
        end
      end
    end
  end
end

