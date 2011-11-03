
module Clouddns
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'clouddns/tasks.rb'
    end
  end
end

