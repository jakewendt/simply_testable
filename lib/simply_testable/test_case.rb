module SimplyTestable::TestCase

	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
#			class << self
				alias_method_chain :method_missing, :create_object
#			end
		end
	end

	module ClassMethods

		#	I don't like this quick and dirty name
		def st_model_name
			self.name.demodulize.sub(/Test$/,'')
		end

	end

	module InstanceMethods

		def model_name
#			self.class.name.sub(/Test$/,'')
#			self.class.name.demodulize.sub(/Test$/,'')
			self.class.st_model_name
		end

		def method_missing_with_create_object(symb,*args, &block)
			method = symb.to_s
#			if method =~ /^create_(.+)(\!?)$/
			if method =~ /^create_([^!]+)(!?)$/
				factory = if( $1 == 'object' )
#	doesn't work for controllers yet.  Need to consider
#	singular and plural as well as "tests" method.
#	Probably should just use the explicit factory
#	name in the controller tests.
#				self.class.name.sub(/Test$/,'').underscore
					model_name.underscore
				else
					$1
				end
				bang = $2
				options = args.extract_options!
				if bang.blank?
					record = Factory.build(factory,options)
					record.save
					record
				else
					Factory(factory,options)
				end
			else
#				super(symb,*args, &block)
				method_missing_without_create_object(symb,*args, &block)
			end
		end

	end	#	InstanceMethods
end	#	SimplyTestable::TestCase
require 'active_support'
require 'active_support/test_case'
ActiveSupport::TestCase.send(:include,
	SimplyTestable::TestCase)
