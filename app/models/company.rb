class Company < ActiveRecord::Base
	validates_presence_of :name, :tel_office
	validates_uniqueness_of :name
	has_many :numbers, -> {order("id DESC")}
	has_many :bills, -> {order("id DESC")}
	belongs_to :company_import_log
	belongs_to :issue_number_import_log
end
