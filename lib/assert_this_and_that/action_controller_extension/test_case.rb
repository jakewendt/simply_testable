module AssertThisAndThat::ActionControllerExtension
module TestCase

	def turn_https_on
		@request.env['HTTPS'] = 'on'
#		@request.env['HTTP_X_FORWARDED_PROTO'] == 'https'
	end

	def turn_https_off
		@request.env['HTTPS'] = nil
	end

	def assert_layout(layout)
		layout = "layouts/#{layout}" unless layout.match(/^layouts/)
		assert_equal layout, @response.layout
	end

end	#	module TestCase
end	#	module AssertThisAndThat::ActionControllerExtension
require 'action_controller'
require 'action_controller/test_case'
ActionController::TestCase.send(:include,
	AssertThisAndThat::ActionControllerExtension::TestCase)
