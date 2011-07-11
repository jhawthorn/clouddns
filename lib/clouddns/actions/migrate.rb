require 'clouddns/actions/print_record'

module Clouddns
  module Actions
    class Migrate < GenericAction
      include PrintRecord

      def run
        @fog = Fog::DNS.new(@options[:fog])

        @fog_zone = @fog.zones.find { |z| z.domain == @zone.name }

        puts
        puts "Migrating '#{@zone.name}'"

        unless @fog_zone
          puts
          puts "Zone '#{@zone.name}' does not exist. Creating..."
          require_confirmation!
          @fog_zone = @fog.zones.create(:domain => @zone.name)
          puts "Zone '#{@zone.name}' created."
        end

        # required to pick up nameservers
        @fog_zone = @fog_zone.reload

        puts
        puts "Nameservers:"
        @fog_zone.nameservers.each do |nameserver|
          puts "  #{nameserver}"
        end

        puts
        puts "Changes:"
        @records_to_remove = []
        @records_to_add = []

        @namelength = (@fog_zone.records.map(&:name) + @zone.records.map(&:name)).map(&:length).max

        @actions = []

        fog_records = Hash[@fog_zone.records.map {|r| [[r.name.gsub('\052', '*'), r.type], r] } ]
        @zone.records.each do |record|
          if (fog_record = fog_records.delete([record.name, record.type]))
            if equal?(record, fog_record)
              @actions << [' ', record]
            else
              @actions << ['-', fog_record]
              @actions << ['+', record]
            end
          else
            @actions << ['+', record]
          end
        end

        fog_records.each do |name, record|
          @actions << ['-', record]
        end

        @actions.each do |(action, record)|
          print_record record, @namelength, action
        end

        # no changes required
        return if @actions.all? {|(action, record)| action == ' ' }

        require_confirmation!

        @actions.each do |(action, record)|
          if action == '+'
            @fog_zone.records.create(:type => record.type, :name => record.name, :ip => record.value, :ttl => record.ttl)
          elsif action == '-'
            record.destroy
          end
        end
        puts "Done"
      end

      private

      def equal? record, fog_record
        # AWS replaces * with \052
        record.name == fog_record.name.gsub('\052', '*') &&
          record.type == fog_record.type &&
          record.value == fog_record.ip &&
          record.ttl.to_i == fog_record.ttl.to_i
      end

      def require_confirmation!
        print "Type 'Yes' to continute: "
        STDOUT.flush

        unless STDIN.readline.strip == 'Yes'
          puts "aborting"
          exit 1
        end
      end
    end
  end
end

