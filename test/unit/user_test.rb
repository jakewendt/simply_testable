require 'test_helper'

class UserTest < ActiveSupport::TestCase

	assert_should_require_attributes( :name )
	assert_should_require_attribute_length( :name,
		:minimum => 5, :maximum => 250 )
	assert_should_require_unique_attributes( :name )
	assert_should_have_one( :blog, :foreign_key => 'owner_id'	)
	assert_should_have_many( :posts, :foreign_key => 'author_id'	)

end
