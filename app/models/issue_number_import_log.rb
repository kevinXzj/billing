class IssueNumberImportLog < ImportLog
  
	has_many :issue_numbers, dependent: :destroy
	has_many :companies, dependent: :destroy
	has_many :customers, dependent: :destroy
	has_many :numbers, dependent: :destroy

	def self.build(tmp_file)
    ActiveRecord::Base.transaction do
  		base_hash = save_upload_file(tmp_file)
      data = read_data(base_hash[:file_path])
      issue_number_import_log = IssueNumberImportLog.create(base_hash)
      new_update_count_hash = {
      	company:0,
      	customer:0,
      	number:0,
      	new_issue_number:0,
      	update_issue_number:0,
      	empty_count:data[:empty_count],
      	re_issue_number_count:data[:re_issue_number_count]
      }
      errors = []
      data[:data].each do |row|
        row_num = row[:row_num]
        issueNumber = row[:issueNumber]
      	number = Number.find_or_create_by!(phone_num:issueNumber.number.phone_num) do |n|
       		n.real_num = issueNumber.number.real_num
       		n.apply_at = Time.new
       		company = Company.find_or_create_by!(name:issueNumber.number.company.name) do |c|
  	     		c.tel_office = issueNumber.number.company.tel_office
  	     		c.issue_number_import_log = issue_number_import_log
  	     		new_update_count_hash[:company] += 1
  	    	end
  	    	n.company = company
       		n.issue_number_import_log = issue_number_import_log
       		new_update_count_hash[:number] += 1
      	end
      	customer = Customer.find_or_create_by!(name:issueNumber.customer.name) do |c|
      		c.issue_number_import_log = issue_number_import_log
      		new_update_count_hash[:customer] += 1
      	end
      	is = IssueNumber.find_by(number_id:number.id,customer_id:customer.id)
      	if is.nil?
  	    	is = IssueNumber.new(
  	    		number_id:number.id,
  	    		customer_id:customer.id,
  	    		issue_at:issueNumber.issue_at,
  	    		back_at:issueNumber.back_at,
  	    		issue_number_import_log:issue_number_import_log
  	    		)
  	    	new_update_count_hash[:new_issue_number] += 1
      	else
          #如果有相同的记录,默认更新记录(只覆盖不新增)
      		is.issue_at = issueNumber.issue_at
      		is.back_at = issueNumber.back_at
      		new_update_count_hash[:update_issue_number] += 1
      	end
        # is.save(validate: false)
        # is.save!
        begin
          is.save!
        rescue Exception => e
          errors << "第#{row_num}行,#{e}"
        end
      end
      unless errors.blank?
        raise errors.join(ImportLog::FILE_TAG)
      end
      remark_list =["导入成功"]
      remark_list.push("新套餐#{new_update_count_hash[:company]}个") if new_update_count_hash[:company]>0
      remark_list.push("新号码#{new_update_count_hash[:number]}个") if new_update_count_hash[:number]>0
      remark_list.push("新客户#{new_update_count_hash[:customer]}个") if new_update_count_hash[:customer]>0
      remark_list.push("新分配记录#{new_update_count_hash[:new_issue_number]}个") if new_update_count_hash[:new_issue_number]>0
      remark_list.push("更新分配记录#{new_update_count_hash[:update_issue_number]}个") if new_update_count_hash[:update_issue_number]>0
      remark_list.push("回收再分配记录#{new_update_count_hash[:re_issue_number_count]}个") if new_update_count_hash[:re_issue_number_count]>0
      remark_list.push("去掉空行#{new_update_count_hash[:empty_count]}条") if new_update_count_hash[:empty_count]>0
         
      issue_number_import_log.remark = remark_list.join(",")
  		return issue_number_import_log
    end
	end

	private
  def self.read_data(file)
    data = []
    errors = []
    empty_count = 0
    re_issue_number_count = 0
    xlsx = Roo::Spreadsheet.open(file)
    xlsx.each_row_streaming(offset: 1) do |row|
      validates_info = []
      unless row[0].blank?
        company_tel_office = row[0].cell_value.strip
        row_num = row[0].coordinate.row
      end
      company_name = row[1].cell_value.strip unless row[1].blank?
      number_phone_num = row[2].cell_value.strip unless row[2].blank?
      number_real_num = row[3].cell_value.strip unless row[3].blank?
      customer_name = row[4].cell_value.strip unless row[4].blank?
      issue_number_issue_at = row[5].cell_value.strip unless row[5].blank?
      issue_number_back_at = row[6].cell_value.strip unless row[6].blank?
      issue_number_re_issue_at = row[7].cell_value.strip unless row[7].blank?
      if company_tel_office.blank? &&
        company_name.blank? &&
        number_phone_num.blank? &&
        number_real_num.blank? &&
        customer_name.blank? &&
        issue_number_issue_at.blank? &&
        issue_number_back_at.blank? &&
        issue_number_re_issue_at.blank? 
        empty_count += 1
        next
      end

      validates_info << "套餐名称不能为空" if company_name.blank?
      validates_info << "电话号码不能为空" if number_phone_num.blank?
      validates_info << "当前客户不能为空" if customer_name.blank?

      begin
        issue_number_issue_at = read_date(issue_number_issue_at,false)
      rescue Exception => e
        validates_info << "发放时间数据错误"
      end

      begin
        issue_number_back_at = read_date(issue_number_back_at,false)
      rescue Exception => e
        validates_info << "回收时间数据错误"
      end


      if validates_info.empty?
        customers = customer_name.gsub("，",",").split(",")
        issueNumber = IssueNumber.new do |i|
          i.customer = Customer.new(name:customers[0])
          company = Company.new(name:company_name,tel_office:company_tel_office)
          i.number = Number.new(phone_num:number_phone_num,real_num:number_real_num,company:company)
          i.issue_at = issue_number_issue_at
          i.back_at = issue_number_back_at
        end
        data << {row_num:row_num,issueNumber:issueNumber}
        if customers.size > 1

          begin
            issue_number_re_issue_at = read_date(issue_number_re_issue_at,false)
          rescue Exception => e
            validates_info << "下单时间数据错误"
          end

          re_issueNumber = IssueNumber.new do |i|
            i.customer = Customer.new(name:customers[1])
            company = Company.new(name:company_name,tel_office:company_tel_office)
            i.number = Number.new(phone_num:number_phone_num,real_num:number_real_num,company:company)
            i.issue_at = issue_number_re_issue_at
          end 
          data << {row_num:row_num,issueNumber:re_issueNumber}
          re_issue_number_count += 1
        end
      else
        validates_info.unshift("第#{row_num}行")
        errors << validates_info.join(",")
      end
    end
    unless errors.empty? 
      ImportLog.delete_file_by file
      raise errors.join(ImportLog::FILE_TAG)
    end
    if data.blank?
      ImportLog.delete_file_by file
      raise "无数据,请重新导入."
    end
    {data:data,errors:errors,empty_count:empty_count,re_issue_number_count:re_issue_number_count}
  end

	def self.read_date(date,need_init)
		if date.blank?
			Time.now if need_init
		else
			count = date.scan('.').length
			if count > 0
				raise "格式错误" unless count==2
			end
			Time.parse(date)
		end
	end
  
end