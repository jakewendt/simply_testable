class Post < ActiveRecord::Base
	acts_as_list :scope => :blog_id
	belongs_to :blog, :counter_cache => true
	validates_presence_of :title
	validates_length_of   :title, :maximum => 250
end
