class CreateImportLogs < ActiveRecord::Migration
  def change
    create_table :import_logs do |t|
      t.string :file_name
      t.string :file_path
      t.string :type
      t.text :remark

      t.timestamps null: false
    end
  end
end
