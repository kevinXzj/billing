class RemoveCompanyIdToBill < ActiveRecord::Migration
  def change
  	remove_reference :bills, :company, foreign_key: true
  end
end
