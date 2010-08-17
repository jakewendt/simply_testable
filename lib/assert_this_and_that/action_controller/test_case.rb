module AssertThisAndThat
module ActionController
module TestCase

	def turn_https_on
		@request.env['HTTPS'] = 'on'
#		@request.env['HTTP_X_FORWARDED_PROTO'] == 'https'
	end

	def turn_https_off
		@request.env['HTTPS'] = nil
	end

end	#	module TestCase
end	#	module ActionController
end	#	module AssertThisAndThat
ActionController::TestCase.send(:include,
	AssertThisAndThat::ActionController::TestCase)
