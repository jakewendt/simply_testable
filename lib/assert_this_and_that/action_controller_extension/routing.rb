module AssertThisAndThat::ActionControllerExtension
module Routing

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

#		def assert_route
#		end

		def assert_no_route(verb,action,args={})
			test "@@ no route to #{verb} #{action} #{args}" do
				assert_raise(ActionController::RoutingError){
					send(verb,action,args)
				}
			end
		end

	end	# module ClassMethods
end	#	module Routing
end	#	module AssertThisAndThat::ActionControllerExtension
require 'action_controller'
require 'action_controller/test_case'
ActionController::TestCase.send(:include, 
	AssertThisAndThat::ActionControllerExtension::Routing)
