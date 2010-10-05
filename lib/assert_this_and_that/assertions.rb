module AssertThisAndThat::Assertions

	def self.included(base)
		base.extend ClassMethods
		base.send(:include,InstanceMethods)
	end

	module ClassMethods

	end	# ClassMethods

	module InstanceMethods

		#	basically a copy of assert_difference, but
		#	without any explicit comparison as it is 
		#	simply stating that something will change
		#	(designed for updated_at)
		def assert_changes(expression, message = nil, &block)
			b = block.send(:binding)
			exps = Array.wrap(expression)
			before = exps.map { |e| eval(e, b) }
			yield
			exps.each_with_index do |e, i|
				error = "#{e.inspect} didn't change"
				error = "#{message}.\n#{error}" if message
				assert_not_equal(before[i], eval(e, b), error)
			end
		end

		#	Just a negation of assert_changes
		def deny_changes(expression, message = nil, &block)
			b = block.send(:binding)
			exps = Array.wrap(expression)
			before = exps.map { |e| eval(e, b) }
			yield
			exps.each_with_index do |e, i|
				error = "#{e.inspect} changed"
				error = "#{message}.\n#{error}" if message
				assert_equal(before[i], eval(e, b), error)
			end
		end

	end	#	InstanceMethods

end	# module AssertThisAndThat::Assertions
require 'active_support'
require 'active_support/test_case'
ActiveSupport::TestCase.send(:include,
	AssertThisAndThat::Assertions)
