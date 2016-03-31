class IssueNumber < ActiveRecord::Base
	scope :active, ->(time) { where("issue_numbers.back_at < ? or issue_numbers.back_at is null", time) }
	# scope :active_nubmer_bill_items, ->(time,year,month){active(time).joins("
	# 		left join numbers on numbers.id = issue_numbers.number_id
 #      left join 
 #      (
 #        select bill_items.* from bill_items
 #        inner join bills on bills.id=bill_items.bill_id and bills.year=#{year} and bills.month = #{month}
 #      ) as bill_times_n on bill_times_n.number_id = numbers.id 
	# 	")}
	belongs_to :customer
	belongs_to :number
	belongs_to :issue_number_import_log
end
