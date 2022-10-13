# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2022, by Samuel Williams.
# Copyright, 2020, by Scott Tadman.

require 'rspec/files/leaks'
require 'rspec/core/sandbox'
require 'tempfile'

RSpec.describe RSpec::Files::Leaks do
	include_context RSpec::Files::Leaks
	
	it "leaks IO instances" do
		expect(before_ios).to be == current_ios
	
		input, output = IO.pipe
	
		expect(before_ios).to_not be == current_ios
	
		input.close
		output.close
	
		expect(before_ios).to be == current_ios
	end
	
	it "fails if it leaks IO instances" do
		group = RSpec::Core::Sandbox.sandboxed{RSpec.describe}
		group.include_context RSpec::Files::Leaks
		
		pipe = nil
		
		group.example("leaky example") do
			pipe = IO.pipe
		end
		
		result = group.run
		
		pipe.each(&:close)
		
		expect(result).to be_falsy
	end
	
	it "shouldn't leak io" do
		# I've seen this create ios which are finalised.
		ok = `echo OK`
	end
end
