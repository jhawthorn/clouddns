
module Clouddns
  module Actions
    class Print < GenericAction
      def run
        print_all
      end

      protected
      def print_all
        puts "Zone '#{@zone.name}'"
        namelength = @zone.records.map{ |x| x.name.length }.max
        @zone.records.each do |record|
          puts Utils::format_record record, :namelength => namelength
        end
      end
    end
  end
end

