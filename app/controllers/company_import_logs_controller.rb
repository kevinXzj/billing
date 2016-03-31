class CompanyImportLogsController < ApplicationController
  before_action :set_companyImportLog, only: [:show, :edit, :update, :destroy]

  # GET /company_import_log
  # GET /company_import_log.json
  def index
  	 @company_import_log_grid = initialize_grid(CompanyImportLog, 
      order:'id', 
      order_direction: 'desc')
  end

  def show
    @companies_grid = initialize_grid(Company, 
        conditions: "company_import_log_id = #{@company_import_log.id}",
        order: 'id', 
        order_direction: 'desc')
  end

  def download
    send_file "#{Rails.root}/public/templet/company.xlsx",filename:"套餐导入模板.xlsx"
  end

  def upload
    # @company_import_log = companyImportLog_params()
    @company_import_log = CompanyImportLog.build(params[:file])
    @company_import_log.save!
    respond_to do |format|
      format.html { redirect_to @company_import_log, notice: '上传成功'}
    end
  rescue => e
    @errors =  e.message.split(ImportLog::FILE_TAG)
    respond_to do |format|
      format.html { render 'error'}
    end
  end

  def destroy
    @company_import_log.destroy
    respond_to do |format|
      format.html { redirect_to company_import_logs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

	private
    def set_companyImportLog
      @company_import_log = CompanyImportLog.find(params[:id])
    end

end
