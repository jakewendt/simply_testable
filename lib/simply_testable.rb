def brand
	"@@ "
end
module SimplyTestable
#	predefine namespaces
module ActiveSupportExtension
end
module ActiveRecordExtension
end
module ActionControllerExtension
end
end
#
#	This may require the addition of other gem requirements
#
require 'simply_testable/active_support_extension'
require 'simply_testable/active_record_extension'
require 'simply_testable/action_controller_extension'
