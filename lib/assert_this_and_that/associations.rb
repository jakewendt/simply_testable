module AssertThisAndThat::Associations

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_should_initially_belong_to(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize

				title = "ATnT should initially belong to #{assoc}"
				if !user_options[:class_name].blank?
					title << " ( #{user_options[:class_name]} )"
					class_name = user_options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_not_nil object.send(assoc)
					if object.send(assoc).respond_to?(
						"#{model.underscore.pluralize}_count")
						assert_equal 1, object.reload.send(assoc).send(
							"#{model.underscore.pluralize}_count")
					end
					if !user_options[:class_name].blank?
						assert object.send(assoc).is_a?(class_name.constantize)
					end
				end

			end

		end

		def assert_should_belong_to(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize
				title = "ATnT should belong to #{assoc}" 
#				if !user_options[:as].blank?
#					title << " as #{user_options[:as]}"
#					as = user_options[:as]
#				end
				if !user_options[:class_name].blank?
					title << " ( #{user_options[:class_name]} )"
					class_name = user_options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_nil object.send(assoc)
					object.send("#{assoc}=",Factory(class_name.underscore))
					assert_not_nil object.send(assoc)
					assert object.send(assoc).is_a?(class_name.constantize)
				end

			end

		end

		def assert_should_have_one(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				assoc = assoc.to_s

				test "ATnT should have one #{assoc}" do
					object = create_object
					assert_nil object.send(assoc)
					Factory(assoc, "#{model.underscore}_id".to_sym => object.id)
					assert_not_nil object.reload.send(assoc)
					object.send(assoc).destroy
					assert_nil object.reload.send(assoc)
				end

			end

		end

		def assert_should_have_many_(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')

			foreign_key = if !user_options[:foreign_key].blank?
				user_options[:foreign_key].to_sym
			else
				"#{model.underscore}_id".to_sym
			end

			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize

				title = "ATnT should have many #{assoc}"
				if !user_options[:class_name].blank?
					title << " ( #{user_options[:class_name]} )"
					class_name = user_options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_equal 0, object.send(assoc).length
					Factory(class_name.singularize.underscore, 
						foreign_key => object.id)
#	doesn't work for all
#object.send(assoc) << Factory(assoc.singularize)
					assert_equal 1, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 1, object.reload.send("#{assoc}_count")
					end
					Factory(class_name.singularize.underscore, 
						foreign_key => object.id)
					assert_equal 2, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 2, object.reload.send("#{assoc}_count")
					end
				end

			end

		end
		alias_method :assert_should_have_many, 
			:assert_should_have_many_
		alias_method :assert_should_have_many_associations, 
			:assert_should_have_many_

		def assert_should_habtm(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				assoc = assoc.to_s

				test "ATnT should habtm #{assoc}" do
					object = create_object
					assert_equal 0, object.send(assoc).length
					object.send(assoc) << Factory(assoc.singularize)
					assert_equal 1, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 1, object.reload.send("#{assoc}_count")
					end
					object.send(assoc) << Factory(assoc.singularize)
					assert_equal 2, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 2, object.reload.send("#{assoc}_count")
					end
				end

			end

		end

		def assert_requires_valid_associations(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')

			associations.each do |assoc|
				as = assoc = assoc.to_s
				as = user_options[:as] if !user_options[:as].blank?

				test "ATnT should require foreign key #{as}_id" do
					assert_difference("#{model}.count",0) do
						object = create_object("#{as}_id".to_sym => nil)
						assert object.errors.on(as.to_sym)
					end
				end

				test "ATnT should require valid foreign key #{as}_id" do
					assert_difference("#{model}.count",0) do
						object = create_object("#{as}_id".to_sym => 0)
						assert object.errors.on(as.to_sym)
					end
				end

				title = "ATnT should require valid association #{assoc}"
				title << " as #{user_options[:as]}" if !user_options[:as].blank?
				test title do
					assert_difference("#{model}.count",0) { 
						object = create_object(
							as.to_sym => Factory.build(assoc.to_sym))
						assert object.errors.on("#{as}_id".to_sym)
					}    
				end 

			end

		end
		alias_method :assert_should_require_valid_associations,
			:assert_requires_valid_associations
		alias_method :assert_should_require_valid_association,
			:assert_requires_valid_associations
		alias_method :assert_requires_valid_association,
			:assert_requires_valid_associations
		alias_method :assert_requires_valid,
			:assert_requires_valid_associations

	end	# ClassMethods

end	# module AssertThisAndThat::Associations
require 'active_support'
require 'active_support/test_case'
ActiveSupport::TestCase.send(:include,
	AssertThisAndThat::Associations)