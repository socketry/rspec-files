source 'https://rubygems.org'

# Specify your gem's dependencies in rspec-files.gemspec
gemspec

group :maintenance, optional: true do
	gem "bake-modernize"
	gem "bake-bundler"
end
