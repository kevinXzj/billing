class ChangeColumnNumber < ActiveRecord::Migration
  def change
  	rename_column :numbers, :real_number, :real_num
  	rename_column :companies, :bill_number, :bill_num
  end
end
