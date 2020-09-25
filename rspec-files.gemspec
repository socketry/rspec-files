
require_relative "lib/rspec/files/version"

Gem::Specification.new do |spec|
	spec.name = "rspec-files"
	spec.version = RSpec::Files::VERSION
	
	spec.summary = "RSpec helpers for buffering and detecting file descriptor leaks."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/socketry/rspec-files"
	
	spec.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.add_dependency "rspec", "~> 3.0"
	
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
end
