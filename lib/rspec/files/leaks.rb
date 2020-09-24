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

module RSpec
	module Files
		module Leaks
			def current_ios(gc: true)
				GC.start if gc
				
				all_ios = ObjectSpace.each_object(::IO).to_a.sort_by(&:object_id)
				
				# We are not interested in ios that have been closed already:
				return all_ios.reject{|io| io.closed?}
			end

			def created_ios(gc: true)
				GC.start if (gc)

				before_ios = current_ios(gc: gc)

				yield if (block_given?)
				
				GC.start if (gc)

				current_ios(gc: gc) - before_ios
			end
		end
		
		RSpec.shared_context Leaks do
			include Leaks
			
			# We use around(:each) because it's the highest priority.
			around(:each) do |example|
				# Here inspect is used to avoid reporting on handles that cannot
				# be read from, as otherwise RSpec will attempt to test if they are
				# readable and get stuck forever.
				expect(created_ios { example.run }.map(&:inspect)).to eq([ ])
			end
		end
	end
end
