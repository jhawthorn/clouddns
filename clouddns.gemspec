# -*- encoding: utf-8 -*-
require File.expand_path('../lib/clouddns/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Hawthorn"]
  gem.email         = ["john.hawthorn@gmail.com"]
  gem.description   = %q{A DSL for managing DNS through cloud services}
  gem.summary       = %q{A DSL and tools for managing DNS through any of the services supported by fog.  Currently, this is Amazon Route 53, bluebox, DNSimple, DNS Made Easy, Linode DNS, Slicehost DNS and Zerigo DNS }
  gem.homepage      = 'https://github.com/jhawthorn/clouddns'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "clouddns"
  gem.require_paths = ['lib']
  gem.version       = Clouddns::VERSION

  # 0.9.0 changed Record#ip to Record#value
  gem.add_dependency('fog', '>= 0.9.0')
  gem.add_dependency('thor', '~> 0.18.1')
  gem.add_development_dependency('rake')
end
