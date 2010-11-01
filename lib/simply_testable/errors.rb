module SimplyTestable::Errors
	def self.included(base)
		base.send(:include,InstanceMethods)
	end
	module InstanceMethods
		def on_attr_and_type(attribute,type)
			attribute = attribute.to_s
			return nil unless @errors.has_key?(attribute)
			@errors[attribute].collect(&:type).include?(type)
		end
	end
end	#	SimplyTestable::Errors
ActiveRecord::Errors.send(:include,
	SimplyTestable::Errors)
