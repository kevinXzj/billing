class Number < ActiveRecord::Base
	validates_presence_of :real_num, :phone_num, :apply_at, :company_id
	validates_uniqueness_of :real_num,:phone_num
	belongs_to :company
end
