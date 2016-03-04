class CreateNumbers < ActiveRecord::Migration
  def change
    create_table :numbers do |t|
      t.string :phone_num
      t.string :real_number
      t.date :apply_at
      t.integer :company_id

      t.timestamps null: false
    end
    add_foreign_key :numbers, :companies, on_delete: :cascade
  end
end
