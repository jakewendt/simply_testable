require 'test_helper'

class BlogTest < ActiveSupport::TestCase

	assert_should_require_attributes(:title)
#	assert_should_not_require_attributes(
#		:description)

#	assert_requires_valid_associations(:address_type)
#	assert_should_have_one(:addressing)
	assert_should_have_many(:posts)
#	assert_should_belong_to(:data_source)
#	assert_should_initially_belong_to(:address_type)

protected

	alias_method :create_object, :create_blog

end
