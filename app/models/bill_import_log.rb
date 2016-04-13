class BillImportLog < ImportLog
	has_one :bill, dependent: :destroy

	def self.build(tmp_file,year,month)
		base_hash = save_upload_file(tmp_file)
    log = self.new do |l|
      l.file_name = base_hash[:file_name]
      l.file_path = base_hash[:file_path]
    end
    bill = Bill.new do |b|
    	b.year = year
    	b.month = month
    end
    bill.valid?
    if bill.errors.any?
      raise bill.errors.full_messages.to_s
    end

    errors = []
    xlsx = Roo::Spreadsheet.open(base_hash[:file_path])
    xlsx.each_row_streaming(offset: 1) do |row|
      tel_office = row[0].cell_value.strip unless row[0].blank?
      company_name = row[1].cell_value.strip unless row[1].blank?
      phone_num = row[2].cell_value.strip unless row[2].blank?
      voice = row[3].cell_value.strip unless row[3].blank?
      message = row[4].cell_value.strip unless row[4].blank?
      internet = row[5].cell_value.strip unless row[5].blank?
      service = row[6].cell_value.strip unless row[6].blank?
      proxy = row[7].cell_value.strip unless row[7].blank?
    	if tel_office.blank? &&
        company_name.blank? &&
        phone_num.blank? &&
        voice.blank? &&
        message.blank? &&
        internet.blank? &&
        service.blank? &&
        proxy.blank?  
        next
      end
      row_count = row[0].coordinate.row unless row[0].blank?
      bill_item = BillItem.new do |bi|
        # company_id = Company.find_by name:company_name
				# bi.number = Number.joins(:company).find_by("phone_num=:phone_num and companies.name=:company_name",
    #                   {phone_num:phone_num,company_name:company_name})
        bi.number = Number.find_by(phone_num:phone_num)
        bi.voice = voice
        bi.message = message
        bi.internet = internet
        bi.service = service
        bi.proxy = proxy
      end
      # p bill_item.voice.class
      # p bill_item.inspect
      if  bill_item.valid?
        bill.bill_items << bill_item 
      else  
        errors.push("第#{row_count}行:#{bill_item.errors.full_messages}.")
      end
      
    end
    unless errors.empty? 	
    	ImportLog.delete_file_by log.file_path
    	raise errors.join(ImportLog::FILE_TAG) 
    end
    if bill.bill_items.blank?
      ImportLog.delete_file_by log.file_path
      raise "无数据,请重新导入."
    end
    log.bill = bill
    log.remark = "导入数据成功,#{year}年#{month}月的账单包含#{bill.bill_items.size}条明细记录"
    
    # raise "测试"
    return log
	end
end
