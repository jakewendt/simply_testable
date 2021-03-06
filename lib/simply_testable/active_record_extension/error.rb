module SimplyTestable::ActiveRecordExtension::Error
	def self.included(base)
		base.class_eval do
			alias_method_chain :generate_full_message, :attribute_strip unless
				base.respond_to?(:initialize_without_attribute_strip)
			alias_method_chain :initialize, :type_option unless
				base.respond_to?(:initialize_without_type_option)
		end
	end
	def generate_full_message_with_attribute_strip(options = {}, &block)
		m = generate_full_message_without_attribute_strip(options, &block)
		unless( ( i = m.index('<|X|') ).nil? )
			m = m[i+4..-1]
		end
		m
	end
	def initialize_with_type_option(base, attribute, type = nil, options = {})
		initialize_without_type_option(base, attribute, type, options)
		self.type = options[:type] if options.has_key?(:type)
	end
end
ActiveRecord::Error.send(:include,
	SimplyTestable::ActiveRecordExtension::Error)
