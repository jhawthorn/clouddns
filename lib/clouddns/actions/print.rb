module Clouddns
  module Actions
    class Print < GenericAction
      def run
        "Zone '#{@zone.name}'"
        namelen = @zone.records.map{ |x| x.name.length }.max
        @zone.records.each do |record|
          record.value.each_with_index do |value, i|
            if i.zero?
              args = [record.type, record.ttl, record.name, value]
            else
              args = ['', '', '', value]
            end
            puts "%5s %5s %#{namelen}s %s" % args
          end
        end
      end
    end
  end
end
