module Clouddns
  class DSL
    attr_reader :zones

    # This need not be too strict. Only exists to help catch typos.
    DNS_REGEX = /\A.*\..*\.\z/

    def scope options={}
      oldscope = @scope
      @scope = @scope.merge(options)
      yield
      @scope = oldscope
    end

    def initialize
      @zones = []
      @scope = {}
    end

    def self.parse_string string
      dsl = DSL.new
      dsl.instance_eval string
      dsl
    end
    def self.parse_file filename
      parse_string open(filename).read
    end

    def A *args
      add_record 'A', *args
    end
    def CNAME *args
      add_record 'CNAME', *args
    end
    def MX *args
      add_record 'MX', *args
    end
    def NS *args
      add_record 'NS', *args
    end
    def TXT name, value, options={}
      add_record 'TXT', name, "\"#{value}\"", options
    end

    def add_record type, name, value, options={}
      zone = @scope[:zone]

      raise "records must be added inside a zone" unless zone
      raise "record's dns name must end with the current zone" unless name.end_with? zone.name

      @scope[:zone].records << Record.new(type, name, value, options)
    end

    def zone name, &block
      raise "zone must be at the top level" if @scope[:zone]

      zone = Zone.new(name)
      @zones << zone
      scope :zone => zone, &block
    end
  end
end
