class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    @companies_grid = initialize_grid(Company, 
      order:'companies.id', 
      order_direction: 'desc',
      :custom_order => {
        'companies.name' => 'CONVERT( companies.name USING gbk ) COLLATE gbk_chinese_ci '
      })
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: '创建成功' }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: '修改成功' }
        # format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        # format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    notice = '删除成功'
  rescue ActiveRecord::DeleteRestrictionError => e
    puts e.inspect
    notice = '删除失败:包含其他信息无法删除'
  rescue ActiveRecord::StatementInvalid => e
    puts e.inspect
    notice = '删除失败:包含其他信息无法删除'
  rescue Exception => e
    puts e.inspect
    notice = e.message
  ensure
    respond_to do |format|
      format.html { redirect_to companies_url, notice: notice }
      format.json { head :no_content }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :bill_num, :tel_office, :apply_at)
    end
end
