Factory.define :blog do |f|
	f.sequence(:title) { |n| "Title #{n}" }
#	f.sequence(:description) { |n| "Desc#{n}" }
end
Factory.define :post do |f|
	f.association :blog
	f.sequence(:title) { |n| "Title #{n}" }
#	f.sequence(:body) { |n| "Desc#{n}" }
end