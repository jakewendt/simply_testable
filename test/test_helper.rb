ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage

class ActiveSupport::TestCase
	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures  = false
	fixtures :all

	def new_blog(options={})
#		Blog.new({
#			:title => "Fixed Title"
#		}.merge(options))
		Factory.build(:blog,options)
	end

	def create_blog(options={})
		p = new_blog(options)
		p.save
		p
	end

	def new_post(options={})
#		Post.new({
#			:blog_id => create_blog.id,
#			:title => "Fixed Title"
#		}.merge(options))
		Factory.build(:post,options)
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
