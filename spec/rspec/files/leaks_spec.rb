# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
end
