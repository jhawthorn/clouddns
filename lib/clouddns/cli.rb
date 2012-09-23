require 'thor'

module Clouddns
  class CLI < Thor
    # old name
    map 'migrate' => 'push'

    desc 'push FILES', "Update live DNS servers with changes from FILES"
    method_option :force, :type => :boolean, :aliases => "-f"
    method_option :provider, :type => :string, :aliases => "-p"
    def push *files
      opts = {fog: {}}
      opts[:fog][:provider] = options[:provider] if options[:provider]
      opts[:force] = !!options[:force]
      each_zone files do |zone, fog_options|
        puts;puts
        o = opts.merge({fog: opts.fetch(:fog, {}).merge(fog_options)})
        Clouddns::Actions::Migrate.run(zone, o)
      end
    end

    desc '-v ', "Print the current version"
    map "-v" => :version
    def version
      puts Clouddns::VERSION
    end

    desc 'print FILES', "Print the DNS records described by FILES"
    def print *files
      each_zone files do |zone|
        puts;puts
        Clouddns::Actions::Print.run(zone)
      end
    end

    map "zonefile" => 'print -z'

    private

    def each_zone files
      files.each do |file|
        dsl = Clouddns::DSL.parse_file file
        dsl.zones.each do |zone|
          yield zone, dsl.fog_options
        end
      end
    end
  end
end
