class CompanyImportLog < ImportLog
	has_many :companies

	def self.build(tmp_file)
		base_hash = save_upload_file(tmp_file)
    xlsx = Roo::Spreadsheet.open(base_hash[:file_path])
    log = CompanyImportLog.new do |l|
      l.file_name = base_hash[:file_name]
      l.file_path = base_hash[:file_path]
    end
    success_companies =[]
    errors = []
    xlsx.each_row_streaming(offset: 1) do |row|
      company = Company.new do |c|
        c.tel_office = row[0].cell_value.strip
        c.name = row[1].cell_value.strip
        c.bill_num = row[2].cell_value.strip
        c.apply_at = row[3].value if row[3]!=nil
      end
      company.valid?
      if company.errors.any?
        errors.push("第#{row[0].coordinate.row}行:#{company.errors.full_messages}.")
      else  
        success_companies.push(company)
      end
    end
    if success_companies.size > 0
      log.companies = success_companies 
    end
    log.remark = "导入数据成功#{success_companies.size}条"
    unless errors.empty? 	
    	ImportLog.delete_file_by log.file_path
    	raise errors.join(ImportLog::FILE_TAG) 
    end
    if success_companies.blank?
      ImportLog.delete_file_by log.file_path
      raise "无数据,请重新导入."
    end
    return log
	end
end
