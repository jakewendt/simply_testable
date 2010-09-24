module AssertThisAndThat::ShouldRoute

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def assert_no_route(verb,action,args={})
			test "NR no route to #{verb} #{action} #{args}" do
				assert_raise(ActionController::RoutingError){
					send(verb,action,args)
				}
			end
		end

	end	# module ClassMethods
end	#	module AssertThisAndThat::ShouldRoute
require 'action_controller'
require 'action_controller/test_case'
ActionController::TestCase.send(:include, 
	AssertThisAndThat::ShouldRoute)
