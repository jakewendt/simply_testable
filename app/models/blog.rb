class Blog < ActiveRecord::Base
	has_many :posts
	validates_presence_of   :title
	validates_length_of     :title, :minimum => 5
	validates_uniqueness_of :title
end
