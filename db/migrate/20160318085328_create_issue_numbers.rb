class CreateIssueNumbers < ActiveRecord::Migration
  def change
    create_table :issue_numbers do |t|
      t.integer :customer_id, null: false
      t.integer :number_id, null: false
      t.integer :issue_number_import_log_id
      t.date :issue_at, null: false
      t.date :back_at

      t.timestamps null: false
    end
    add_foreign_key :issue_numbers, :customers
    add_foreign_key :issue_numbers, :numbers
    add_foreign_key :issue_numbers, :import_logs, column: :issue_number_import_log_id, primary_key: :id, on_delete: :cascade
  end
end
