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
require 'tempfile'

Signal.trap('QUIT') do
	Thread.list.each do |t|
		puts t.backtrace.join("\n")
	end
end

RSpec.describe "leaks context" do
	include_context RSpec::Files::Leaks

	def retain_leaks
		# Retains references for a short period of time to avoid aggressive
		# garbage collection when they fall out of scope.
		list = [ ]

		yield(list)

		list.clear
	end
	
	it "detects leaked IO objects" do
		expect(created_ios { }.length).to eq(0)

		retain_leaks do |leaks|
			expect(created_ios { leaks << File.open(__FILE__) }.length).to eq(1)
			expect(created_ios { leaks << IO.pipe }.length).to eq(2)
		end

		expect(created_ios { input, output = IO.pipe; input.close; output.close }.length).to eq(0)
	end
end
