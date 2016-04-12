class IssueNumbersController < ApplicationController
	before_action :set_issue_number, only: [:show, :edit, :update, :destroy]

  def index
  	@issue_numbers_grid = initialize_grid(IssueNumber, 
      order:'id', 
      order_direction: 'desc')
  end


  def show
  end

  def new
    @issue_number = IssueNumber.new
    @issue_number.number = Number.find(params[:number_id])
  end

  def edit
  end

  def create
    @issue_number = IssueNumber.new(issue_number_params)

    respond_to do |format|
      if @issue_number.save
        format.html { redirect_to number_path(@issue_number.number_id), notice: '新建成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @issue_number.update(issue_number_params)
        format.html { redirect_to number_path(@issue_number.number_id), notice: '保存成功' }
        format.json { render :show, status: :ok, location: @issue_number }
      else
        format.html { render :edit }
        format.json { render json: @issue_number.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @issue_number.destroy
    notice = '删除成功'
  rescue ActiveRecord::DeleteRestrictionError => e
    puts e.inspect
    notice = '删除失败:包含其他信息无法删除'
  rescue Exception => e
    puts e.inspect
    notice = e.message
  ensure
    respond_to do |format|
      format.html { redirect_to number_path(@issue_number.number_id), notice: notice }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_number
      @issue_number = IssueNumber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_number_params
      params.require(:issue_number).permit(:customer_id, :number_id, :issue_at, :back_at)
    end
end
