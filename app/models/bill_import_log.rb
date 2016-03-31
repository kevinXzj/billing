class BillImportLog < ImportLog
	has_one :bill, dependent: :destroy

	def self.build(tmp_file,company_id,year,month)
		base_hash = save_upload_file(tmp_file)
    log = self.new do |l|
      l.file_name = base_hash[:file_name]
      l.file_path = base_hash[:file_path]
    end
    bill = Bill.new do |b|
    	b.company = Company.find_by(id:company_id)
    	b.year = year
    	b.month = month
    end
    bill.valid?
    if bill.errors.any?
      raise bill.errors.full_messages.to_s
    end

    errors = []
    xlsx = Roo::Spreadsheet.open(base_hash[:file_path])
    xlsx.each_row_streaming(offset: 2) do |row|
    	unless row[0].blank?
    		row_count = row[0].coordinate.row
    		phone = row[0].cell_value.strip 
    	end
      bill_item = BillItem.new do |bi|
				bi.number = Number.find_by(phone_num:phone,company_id:company_id)
        bi.voice = row[1].cell_value.strip unless row[1].blank?
        bi.message = row[2].cell_value.strip unless row[2].blank?
        bi.internet = row[3].cell_value.strip unless row[3].blank?
        bi.service = row[4].cell_value.strip unless row[4].blank?
        bi.proxy = row[5].cell_value.strip unless row[5].blank?
      end
      bill_item.valid?
      if bill_item.errors.any?
        errors.push("第#{row_count}行:#{bill_item.errors.full_messages}.")
      else  
        bill.bill_items << bill_item 
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
    log.remark = "导入数据成功,#{bill.company.name} #{year}年#{month}月的账单包含#{bill.bill_items.size}条明细记录(套餐包含#{bill.company.numbers.size}个号码)"
    return log
	end
end
