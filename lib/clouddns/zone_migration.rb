module Clouddns
  class ZoneMigration
    module Change
      class None < Struct.new(:record)
        def perform! fog_zone
        end
        def print_prefix; ' '; end
        def to_s length=30
          Utils::format_record record, :prefix => print_prefix, :namelength => length
        end
      end
      class Create < None
        def perform! fog_zone
          fog_zone.records.create(:type => record.type, :name => record.name, :value => record.value, :ttl => record.ttl)
        end
        def print_prefix; '+'; end
      end
      class Remove < None
        def perform! fog_zone
          record.destroy
        end
        def print_prefix; '-'; end
      end
    end

    def initialize zone, fog_zone
      @zone = zone
      @fog_zone = fog_zone
      @changes = nil
    end
    def changes
      return @changes if @changes
      @changes = []
      fog_records = Hash[@fog_zone.records.map {|r| [[fog_record_name(r), r.type], r] } ]
      @zone.records.each do |record|
        if (fog_record = fog_records.delete([record.name, record.type]))
          if records_equal?(record, fog_record)
            @changes << Change::None.new(record)
          else
            @changes << Change::Remove.new(fog_record)
            @changes << Change::Create.new(record)
          end
        else
          @changes << Change::Create.new(record)
        end
      end

      fog_records.each do |name, record|
        @changes << Change::Remove.new(record)
      end
      @changes
    end

    def perform!
      changes.each do |change|
        change.perform! @fog_zone
      end
    end

    def completed?
      changes.all? do |change|
        change.class == Change::None
      end
    end

    protected
    def fog_record_name record
      record.name.gsub('\052', '*')
    end

    def records_equal? record, fog_record
      # AWS replaces * with \052
      record.name == fog_record_name(fog_record) &&
        record.type == fog_record.type &&
          (record.value.respond_to?(:sort) ? record.value.sort : record.value) == (fog_record.value.respond_to?(:sort) ? fog_record.value.sort : fog_record.value) &&
        record.ttl.to_i == fog_record.ttl.to_i
    end
  end
end
