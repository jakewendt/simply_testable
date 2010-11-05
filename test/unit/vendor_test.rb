require 'test_helper'

class VendorTest < ActiveSupport::TestCase

	assert_should_require_attributes( :name )
	assert_should_require_attribute_length( :name,
		:minimum => 5, :maximum => 250 )
	assert_should_require_unique_attributes( :name )
	assert_should_habtm( :products )

end
