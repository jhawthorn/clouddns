module Clouddns
  class DSL
    attr_reader :zones
    attr_reader :fog_options

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

    record_types = %w{A AAAA CNAME MX NS PTR SOA SPF SRV TXT}
    record_types.each do |type|
      define_method type do |*args|
        add_record type, *args
      end
    end

    def add_record type, name, value, options={}
      name = Utils::parse_domain(name)

      value = "\"#{value}\"" if type == 'TXT'

      raise "records must be added inside a zone" unless @zone
      raise "record's dns name must end with the current zone" unless name.end_with? @zone.name

      @zone.records << Record.new(type, name, value, options)
    end

    def zone name
      raise "zones cannot be nested" if @zone

      @zone = Zone.new(Utils::parse_domain(name))
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
  end
end

