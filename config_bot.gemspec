# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'config_bot/version'

Gem::Specification.new do |spec|
    spec.name          = "config_bot"
    spec.version       = ConfigBot::VERSION
    spec.authors       = ["Wasiq Bhamla"]
    spec.email         = ["wasbhamla2005@gmail.com"]

    spec.summary       = %q{Config creation helper bot.}
    spec.description   = %q{A helper bot command line utility which helps in creating config file.}
    spec.homepage      = "https://github.com/WasiqB/config_bot"
    spec.license       = "MIT"

    spec.files         = `git ls-files -z`.split("\x0")
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.bindir        = 'exe'
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ["lib"]

    spec.required_ruby_version     = ">= 2.3.0"
    spec.required_rubygems_version = ">= 2.5.0"

    spec.add_development_dependency "bundler", "~> 1.13"
    spec.add_development_dependency "rake", "~> 10.0"
    spec.add_development_dependency "rspec", "~> 3.0"
    spec.add_development_dependency "tty-prompt", "~> 0.7.1"

    spec.add_runtime_dependency 'thor', '~> 0'
end
