class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :bill]
  before_action :set_last_bill_month, only:[:bill]

  # GET /customers
  # GET /customers.json
  def index
     @customers_grid = initialize_grid(Customer, 
      order:'id', 
      order_direction: 'desc')
  end

  def bill
    start_date = Date.parse("#{@year}-#{@month}-1")
    end_date = start_date >> 1
    @issue_numbers_grid = initialize_grid(IssueNumber,
      include: :number,
      per_page:200,
      conditions:["issue_numbers.customer_id= ? and ( (issue_numbers.back_at >= ? and issue_numbers.back_at < ?)  or issue_numbers.back_at is null )",@customer.id,start_date,end_date],
      order:'issue_numbers.id', 
      order_direction: 'desc',
      custom_order:{
        'issue_numbers.number_id' => 'numbers.phone_num'
      },
      enable_export_to_csv: true,
      # csv_field_separator: ';',
      csv_file_name:"#{@customer.name}#{@year}年#{@month}月账单"
    )
    export_grid_if_requested('grid' => 'issue_numbers_grid') do
      # usual render or redirect code executed if the request is not a CSV export request
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: '新建成功' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: '修改成功' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    notice = '删除成功'
  rescue ActiveRecord::DeleteRestrictionError => e
    puts e.inspect
    notice = '删除失败:包含其他信息无法删除'
  rescue Exception => e
    puts e.inspect
    notice = e.message
  ensure
    respond_to do |format|
      format.html { redirect_to customers_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :linkman, :phone, :address, :remark)
    end

    def set_last_bill_month
      @bill_list = Bill.select("year,month").group("year,month").order("year desc ,month desc")
      if(params[:year].blank? || params[:month].blank?)
        @year = @bill_list.first.year unless @bill_list.first.blank?
        @month = @bill_list.first.month unless @bill_list.first.blank?
      else
        @year = params[:year]
        @month = params[:month]
      end 
    end
end
