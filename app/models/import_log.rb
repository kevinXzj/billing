class ImportLog < ActiveRecord::Base
  FILE_TAG = '$%^&*'
  @@upload_path = 'public/upload'

  after_destroy :delete_file

  def self.delete_file_by(file)
    if File.exist?(file)
      File.delete(file)
    end
  end

	protected
	def self.save_upload_file(tmp_file)
	  raise "请选择上传文件" if tmp_file.blank?
    FileUtils.mkdir(@@upload_path) unless File.exist?(@@upload_path)
    change_file_name = Array.new(10) {rand(1024).to_s(36)}.join + File.extname(tmp_file.original_filename)
    file = File.join(@@upload_path, change_file_name)
    FileUtils.cp tmp_file.path, file
    delete_file_by(tmp_file.path)
    {file_name:tmp_file.original_filename,file_path:file}
	end

  def delete_file
    ImportLog.delete_file_by(self.file_path)
  end
end
