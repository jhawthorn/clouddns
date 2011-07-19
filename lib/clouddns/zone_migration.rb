module Clouddns
  class ZoneMigration
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
            @changes << [' ', record]
          else
            @changes << ['-', fog_record]
            @changes << ['+', record]
          end
        else
          @changes << ['+', record]
        end
      end

      fog_records.each do |name, record|
        @changes << ['-', record]
      end
      @changes
    end

    def perform!
      changes.each do |(action, record)|
        if action == '+'
          @fog_zone.records.create(:type => record.type, :name => record.name, :ip => record.value, :ttl => record.ttl)
        elsif action == '-'
          record.destroy
        end
      end
    end

    def completed?
      changes.all? do |(action, record)|
        action == ' '
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
        record.value == fog_record.value &&
        record.ttl.to_i == fog_record.ttl.to_i
    end
  end
end
