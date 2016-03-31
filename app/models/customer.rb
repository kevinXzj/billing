class Customer < ActiveRecord::Base
	validates_presence_of :name
	validates_uniqueness_of :name
	has_many :issue_numbers, -> {order("issue_numbers.id DESC")}, dependent: :restrict_with_exception
	belongs_to :issue_number_import_log
end
