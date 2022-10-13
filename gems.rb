# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2022, by Samuel Williams.

source 'https://rubygems.org'

# Specify your gem's dependencies in rspec-files.gemspec
gemspec

group :maintenance, optional: true do
	gem "bake-modernize"
	gem "bake-gem"
end

group :test do
	gem "rspec"
	gem "bake-test"
end
