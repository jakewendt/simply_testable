class User < ActiveRecord::Base
	has_one  :blog,  :foreign_key => 'owner_id'
	has_many :posts, :foreign_key => 'author_id'
	validates_presence_of   :name
	validates_length_of     :name, :in => 5..250
	validates_uniqueness_of :name
end
