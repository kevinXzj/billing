class IssueNumberImportLogsController < ApplicationController
	before_action :set_IssueNumberImportLog, only: [:show, :destroy]

  def index
  	@issue_number_import_log_grid = initialize_grid(IssueNumberImportLog,
  		order:"id",
  		order_direction:"desc")
  end

  def upload
  	tmp = params[:file]
  	@issue_number_import_log = IssueNumberImportLog.build(tmp)
  	@issue_number_import_log.save
  	respond_to do |format|
      format.html { redirect_to @issue_number_import_log, notice: '上传成功'}
    end
  rescue => e
  	@errors = e.message.split(ImportLog::FILE_TAG)
    respond_to do |format|
      format.html { render 'error'}
    end
  end

  def download
    send_file "#{Rails.root}/public/templet/base.xlsx",filename:"基础数据导入模板.xlsx"
  end

  def show
  	
  end

	def destroy
    @issue_number_import_log.destroy
    respond_to do |format|
      format.html { redirect_to issue_number_import_logs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  def set_IssueNumberImportLog
  	@issue_number_import_log = IssueNumberImportLog.find(params[:id])
  end
end
