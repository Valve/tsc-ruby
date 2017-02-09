require File.expand_path('../lib/tsc-ruby/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'tsc-ruby'

  gem.authors       = ['Valentin Vasilyev']
  gem.email         = ['valentin.vasilyev@outlook.com']
  gem.description   = %q{TypeScript compiler interface for Ruby}
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/valve/tsc-ruby'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = TypeScript::Ruby::VERSION

  gem.add_dependency 'tsrc'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry-byebug'

  gem.required_ruby_version = '>= 1.9.3'
end
