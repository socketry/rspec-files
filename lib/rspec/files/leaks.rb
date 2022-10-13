# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2019-2022, by Samuel Williams.
# Copyright, 2020, by Scott Tadman.

module RSpec
	module Files
		module Leaks
			def current_ios(gc: true)
				GC.start if gc
				
				all_ios = ObjectSpace.each_object(::IO).to_a.sort_by(&:object_id)
				
				# We are not interested in ios that have been closed already:
				return all_ios.reject do |io|
					# It's possible to get errors if the IO is finalised.
					io.closed? rescue true
				end
			rescue RuntimeError => error
				# This occurs on JRuby.
				warn error.message
				
				return []
			end
		end
		
		RSpec.shared_context Leaks do
			include Leaks
			
			let(:before_ios) {current_ios}
			let(:leaked_ios) {current_ios - before_ios}
			
			# We use around(:each) because it's the highest priority.
			around(:each) do |example|
				# Here inspect is used to avoid reporting on handles that cannot
				# be read from, as otherwise RSpec will attempt to test if they are
				# readable and get stuck forever.
				before_ios
				
				example.run.tap do
					expect(leaked_ios).to be_empty
				end
			end
		end
	end
end
