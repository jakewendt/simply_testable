def brand
	"@@ "
end
module SimplyTestable
module ActionControllerExtension
#	predefine namespaces
end
end
#
#	This may require the addition of other gem requirements
#
require 'active_support/test_case'
require 'simply_testable/test_case'
require 'simply_testable/declarative'
require 'simply_testable/assertions'
require 'simply_testable/acts_as_list'
require 'simply_testable/associations'
require 'simply_testable/attributes'
require 'simply_testable/action_controller_extension'
require 'simply_testable/errors'
require 'simply_testable/pending'

module ActiveSupport
	module Testing
		module AtExit
			at_exit { 
				puts Dir.pwd() 
				puts Time.now
			}
		end
	end
end
ActiveSupport::TestCase.send(:include, ActiveSupport::Testing::AtExit)
