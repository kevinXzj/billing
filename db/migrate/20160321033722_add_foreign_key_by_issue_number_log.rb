class AddForeignKeyByIssueNumberLog < ActiveRecord::Migration
  def change
  	add_column :companies, :issue_number_import_log_id, :integer
  	add_foreign_key :companies, :import_logs, column: :issue_number_import_log_id, primary_key: :id, on_delete: :cascade
  	
  	add_column :customers, :issue_number_import_log_id, :integer
  	add_foreign_key :customers, :import_logs, column: :issue_number_import_log_id, primary_key: :id, on_delete: :cascade
  
  	add_column :numbers, :issue_number_import_log_id, :integer
  	add_foreign_key :numbers, :import_logs, column: :issue_number_import_log_id, primary_key: :id, on_delete: :cascade
  end
end
