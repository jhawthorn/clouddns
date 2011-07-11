require 'clouddns/actions/print_record'

module Clouddns
  module Actions
    class Print < GenericAction
      include PrintRecord

      def run
        print_all
      end

      protected
      def print_all
        puts "Zone '#{@zone.name}'"
        namelength = @zone.records.map{ |x| x.name.length }.max
        @zone.records.each do |record|
          print_record record, namelength
        end
      end
    end
  end
end

