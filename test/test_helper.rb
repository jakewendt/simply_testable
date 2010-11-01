ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage

class ActiveSupport::TestCase
	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures  = false
	fixtures :all

	def new_post(options={})
		Post.new({
			:title => "Fixed Title"
		}.merge(options))
	end

	def create_post(options={})
		p = new_post(options)
		p.save
		p
	end

end

class ActionController::TestCase

	setup :turn_https_on

end
