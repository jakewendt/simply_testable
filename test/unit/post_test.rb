require 'test_helper'

class PostTest < ActiveSupport::TestCase

	assert_should_require(:title)

protected

	alias_method :create_object, :create_post

end
