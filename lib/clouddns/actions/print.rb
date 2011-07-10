module Clouddns
  module Actions
    class Print < GenericAction
      def run
        "Zone '#{@zone.name}'"
        namelen = @zone.records.map{ |x| x.name.length }.max
        @zone.records.each do |record|
          puts "%5s %5s %#{namelen}s %s" % [record.type, record.ttl, record.name, record.value]
        end
      end
    end
  end
end
