
require_relative 'lib/rspec/files/version'

Gem::Specification.new do |spec|
	spec.name          = "rspec-files"
	spec.version       = RSpec::Files::VERSION
	spec.licenses      = ["MIT"]
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = "RSpec helpers for buffering and detecting file descriptor leaks."
	spec.homepage      = "https://github.com/socketry/rspec-files"

	spec.files         = `git ls-files -z`.split("\x0").reject do |f|
		f.match(%r{^(test|spec|features)/})
	end
	
	spec.require_paths = ["lib"]
	
	spec.add_dependency "rspec", "~> 3.0"
	
	spec.add_development_dependency "covered"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "rake", "~> 10.0"
end
