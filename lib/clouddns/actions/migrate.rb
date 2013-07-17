
module Clouddns
  module Actions
    class Migrate < GenericAction
      def run
        require 'fog'

        @fog = Fog::DNS.new(@options[:fog])
        @fog_zone = @fog.zones.find { |z| z.domain == @zone.name }

        puts
        puts "Migrating '#{@zone.name}'"

        unless @fog_zone
          @fog_zone = create_zone!
        end

        # required to pick up nameservers and records
        @fog_zone.reload

        print_nameservers

        @migration = ZoneMigration.new(@zone, @fog_zone)

        print_changes

        # no changes required
        return if @migration.completed?

        require_confirmation!

        @migration.perform!

        puts "Done"
      end

      private

      def create_zone!
        puts
        puts "Zone '#{@zone.name}' does not exist. Creating..."
        require_confirmation!
        fog_zone = @fog.zones.create(:domain => @zone.name)
        puts "Zone '#{@zone.name}' created."
      end

      def print_nameservers
        puts
        puts "Nameservers:"
        @fog_zone.nameservers.each do |nameserver|
          puts "  #{nameserver}"
        end
      end

      def print_changes
        namelength = @migration.changes.map do |change|
          change.record.name.length
        end.max

        puts
        puts "Changes:"

        @migration.changes.each do |change|
          puts change.to_s(namelength)
        end
      end

      def require_confirmation!
        unless yes?('continue?')
          exit 1
        end
      end
    end
  end
end

