class Company < ActiveRecord::Base
	validates_presence_of :name, :bill_num, :tel_office, :apply_at
	validates_length_of :bill_num, :minimum => 10 #最少10
	validates_uniqueness_of :bill_num

	has_many :numbers
	# paginates_per 2
end
