class BillItem < ActiveRecord::Base
	scope :active, ->(year,month) { joins(:bill).where("bills.year = ? and bills.month=?", year,month) }
	# validates_presence_of :voice, :message, :internet, :service, :proxy
	validates_presence_of :number,:message =>"不能为空或在套餐下未找到该号码"
	belongs_to :bill
	belongs_to :number
end
