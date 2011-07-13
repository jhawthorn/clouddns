module Clouddns
  class DSL
    attr_reader :zones
    attr_reader :fog_options

    # This need not be too strict. Only exists to help catch typos.
    DNS_REGEX = /\A.*\..*\.\z/

    def initialize
      @zones = []
      @zone = nil
      @defaults = {}
      @fog_options = {}
    end

    def self.parse_string string
      dsl = DSL.new
      dsl.instance_eval string
      dsl
    end
    def self.parse_file filename
      parse_string open(filename).read
    end

    protected

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
      name = domainname(name)

      raise "records must be added inside a zone" unless @zone
      raise "record's dns name must end with the current zone" unless name.end_with? @zone.name

      @zone.records << Record.new(type, name, value, options)
    end

    def zone name
      raise "zones cannot be nested" if @zone

      @zone = Zone.new(domainname(name))
      @zones << @zone
      yield
      @zone = nil
    end

    def defaults options={}
      if block_given?
        old = @defaults
        @defaults = @defaults.merge(options)
        yield
        @defaults = old
      else
        raise "defaults must either take a block or be before any zone declarations" unless @zones.empty?
        @defaults = @defaults.merge(options)
      end
    end

    def provider name, options={}
      @fog_options = options.merge({:provider => name})
    end

    private
    def domainname name
      if name.end_with? '.'
        name
      else
        "#{name}."
      end
    end
  end
end
