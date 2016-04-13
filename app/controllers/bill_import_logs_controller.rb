class BillImportLogsController < ApplicationController
	before_action :set_billImportLog, only: [:show, :edit, :update, :destroy]

	def index
		@bill_import_log_grid = initialize_grid(BillImportLog, 
      order:'id', 
      order_direction: 'desc')
	end

  def download
    send_file "#{Rails.root}/public/templet/bill.xlsx",filename:"账单导入模板.xlsx"
  end

	def show
  end

  def upload
    @bill_import_log =BillImportLog.build(params[:file],params[:year],params[:month])
    @bill_import_log.save!
    respond_to do |format|
      format.html { redirect_to @bill_import_log, notice: '上传成功'}
    end
  rescue => e
    @errors =  e.message.split(ImportLog::FILE_TAG)
    respond_to do |format|
      format.html { render 'error'}
    end
  end

  def destroy
    @bill_import_log.destroy
    respond_to do |format|
      format.html { redirect_to bill_import_logs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

	private
    def set_billImportLog
      @bill_import_log = BillImportLog.find(params[:id])
    end
end
