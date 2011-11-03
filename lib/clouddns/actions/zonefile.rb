
module Clouddns
  module Actions
    class Zonefile < GenericAction
      def run
        print_all
      end

      protected
      def print_all
        puts "$ORIGIN #{@zone.name}"

        namelength = @zone.records.map{ |x| x.name.length }.max
        @zone.records.each do |record|
          record.value.each_with_index do |value, i|
            print "%-18s " % record.name
            print "%5i " % record.ttl
            print "IN "
            print "%-5s " % record.type
            print "%s " % value
            puts
          end
        end
        puts
      end
    end
  end
end

