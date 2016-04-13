class Bill < ActiveRecord::Base
	validates_presence_of :year, :month
	# validates_uniqueness_of :company_id, scope: [:year, :month], :message => "对应账单已经存在"
	validates_uniqueness_of :month, scope: [:year], :message => "对应账单已经存在"
	belongs_to :company
	has_many :bill_items, dependent: :destroy
	belongs_to :bill_import_log
end
