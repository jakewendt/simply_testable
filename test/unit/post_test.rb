require 'test_helper'

class PostTest < ActiveSupport::TestCase

	assert_should_act_as_list( :scope => :blog_id )
	assert_should_require_attributes( :title )
	assert_should_require_attribute_length( :title,
		:maximum => 250 )
	assert_should_not_require_attributes( :body)

#	assert_requires_valid_associations(:address_type)
#	assert_should_have_one(:addressing)
#	assert_should_have_many(:posts)
#	assert_should_belong_to(:blog)
	assert_should_initially_belong_to(:blog)

protected

	alias_method :create_object, :create_post

end
