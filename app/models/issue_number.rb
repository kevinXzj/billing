class IssueNumber < ActiveRecord::Base
	# scope :active, ->(time) { where("issue_numbers.back_at < ? or issue_numbers.back_at is null", time) }
	# scope :active_nubmer_bill_items, ->(time,year,month){active(time).joins("
	# 		left join numbers on numbers.id = issue_numbers.number_id
 #      left join 
 #      (
 #        select bill_items.* from bill_items
 #        inner join bills on bills.id=bill_items.bill_id and bills.year=#{year} and bills.month = #{month}
 #      ) as bill_times_n on bill_times_n.number_id = numbers.id 
	# 	")}
	
	validates_presence_of :customer_id,:number_id
	validate :back_at_cannot_be_less_issue_at,:back_at_cannot_be_nil_than_one
	validate :month_uniqueness_of_number_id_and_customer_id

	belongs_to :customer
	belongs_to :number
	belongs_to :issue_number_import_log

	def back_at_cannot_be_less_issue_at
		if back_at.present? && issue_at.present?
		 	if issue_at > back_at
		 		 errors.add(:back_at, "不能小于分配时间")
		 	end
		end 
	end

	def back_at_cannot_be_nil_than_one
		if back_at.blank?
			if id.present?
				count = IssueNumber.where(" number_id = :number_id and back_at is null and id != :id ",{number_id:number_id,id:id}).count
			else
				count = IssueNumber.where(" number_id = :number_id and back_at is null ",{number_id:number_id}).count
			end
			if count > 0
				errors.add(:issue_number, "存在异常,号码(#{number.phone_num})已经存在一条回收时间为空的记录.")
			end 
		end
	end

	def month_uniqueness_of_number_id_and_customer_id
		if number_id.present? && customer_id.present?
			if id.present?
				count = IssueNumber.where(" number_id = :number_id and customer_id = :customer_id and id != :id ",{number_id:number_id,customer_id:customer_id,id:id}).count
			else
				count = IssueNumber.where(" number_id = :number_id and customer_id = :customer_id ",{number_id:number_id,customer_id:customer_id}).count
			end
			if count > 0
				errors.add(:issue_number, "存在异常,该分配记录已经存在,请修改原记录.")
			end 
		end
	end

end
