class AddForeignKey < ActiveRecord::Migration
  def change
  	add_column :companies, :company_import_log_id, :integer
  	add_foreign_key :companies, :import_logs, column: :company_import_log_id, primary_key: :id, on_delete: :cascade
  	add_column :numbers, :number_import_log_id, :integer
  	add_foreign_key :numbers, :import_logs, column: :number_import_log_id, primary_key: :id, on_delete: :cascade
  end
end
