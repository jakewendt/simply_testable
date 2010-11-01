module SimplyTestable::Attributes

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_should_require_unique_attribute(*attributes)
			user_options = attributes.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			attributes.each do |attr|
				attr = attr.to_s
				title = "@@ should require unique #{attr}"
				scope = user_options[:scope]
				unless scope.blank?
					title << " scope "
					title << (( scope.is_a?(Array) )?scope.join(','):scope.to_s)
				end
				test title do
					o = create_object
					assert_no_difference "#{model}.count" do
						attrs = { attr.to_sym => o.send(attr) }
						if( scope.is_a?(String) || scope.is_a?(Symbol) )
							attrs[scope.to_sym] = o.send(scope.to_sym)
						elsif scope.is_a?(Array)
							scope.each do |s|
								attrs[s.to_sym] = o.send(s.to_sym)
							end
						end 
						object = create_object(attrs)
						assert object.errors.on_attr_and_type(attr.to_sym, :taken)
					end
				end
			end
		end
		alias_method :assert_should_require_unique_attributes, 
			:assert_should_require_unique_attribute
		alias_method :assert_should_require_unique, 
			:assert_should_require_unique_attribute

		def assert_should_require_attribute(*attributes)
			user_options = attributes.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			attributes.each do |attr|
				attr = attr.to_s
				test "@@ should require #{attr}" do
					assert_no_difference "#{model}.count" do
						object = create_object(attr.to_sym => nil)
						assert object.errors.on_attr_and_type(attr.to_sym, :blank)
					end
				end
			end
		end
		alias_method :assert_should_require_attributes, 
			:assert_should_require_attribute
		alias_method :assert_should_require, 
			:assert_should_require_attribute

		def assert_should_not_require_attribute(*attributes)
			user_options = attributes.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			attributes.each do |attr|
				attr = attr.to_s
				test "@@ should not require #{attr}" do
					assert_difference( "#{model}.count", 1 ) do
						object = create_object(attr.to_sym => nil)
						assert !object.errors.on(attr.to_sym)
						if attr =~ /^(.*)_id$/
							assert !object.errors.on($1.to_sym)
						end
					end
				end
			end
		end
		alias_method :assert_should_not_require_attributes, 
			:assert_should_not_require_attribute

		def assert_should_protect_attribute(*attributes)
			user_options = attributes.extract_options!
			model_name = user_options[:model] || self.name.sub(/Test$/,'')
			model = model_name.constantize
			
			attributes.each do |attr|
				attr = attr.to_s
				test "@@ should protect attribute #{attr}" do
					assert model.accessible_attributes||model.protected_attributes,
						"Both accessible and protected attributes are empty"
					assert !(model.accessible_attributes||[]).include?(attr),
						"#{attr} is included in accessible attributes"
					if !model.protected_attributes.nil?
						assert model.protected_attributes.include?(attr),
							"#{attr} is not included in protected attributes"
					end
				end
			end
		end
		alias_method :assert_should_protect_attributes, 
			:assert_should_protect_attribute

		def assert_should_not_protect_attribute(*attributes)
			user_options = attributes.extract_options!
			model_name = user_options[:model] || self.name.sub(/Test$/,'')
			model = model_name.constantize
			
			attributes.each do |attr|
				attr = attr.to_s
				test "@@ should not protect attribute #{attr}" do
					assert !(model.protected_attributes||[]).include?(attr),
						"#{attr} is included in protected attributes"
					if !model.accessible_attributes.nil?
						assert model.accessible_attributes.include?(attr),
							"#{attr} is not included in accessible attributes"
					end
				end
			end
		end
		alias_method :assert_should_not_protect_attributes, 
			:assert_should_not_protect_attribute

	end

end	# module SimplyTestable::Attributes
require 'active_support'
require 'active_support/test_case'
ActiveSupport::TestCase.send(:include,
	SimplyTestable::Attributes)
