# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019, by Samuel Williams.

require 'rspec/files/buffer'

RSpec.describe RSpec::Files::Buffer do
	include_context RSpec::Files::Buffer
	
	it "behaves like a file" do
		expect(buffer).to be_instance_of(File)
	end
	
	it "should not exist on disk" do
		expect(File).to_not be_exist(buffer.path)
	end
end
