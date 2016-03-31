class Number < ActiveRecord::Base
	validates_presence_of  :phone_num, :apply_at, :company_id
	validates_uniqueness_of :phone_num
	belongs_to :company
	belongs_to :number_import_log
	has_many :issue_numbers, -> {order("id DESC")}, dependent: :restrict_with_exception
	belongs_to :issue_number_import_log
	has_many :bill_items, dependent: :restrict_with_exception
end
