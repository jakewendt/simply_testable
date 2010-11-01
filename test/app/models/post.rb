class Post < ActiveRecord::Base
	acts_as_list :scope => :blog_id
	belongs_to :blog
	validates_presence_of :title
end
