class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references :company,:foreign_key => true,null:false
      t.integer :bill_import_log_id
      t.integer :year
      t.integer :month
      t.text :remark

      t.timestamps null: false
    end
  	add_foreign_key :bills, :import_logs, column: :bill_import_log_id, primary_key: :id, on_delete: :cascade
  end
end
