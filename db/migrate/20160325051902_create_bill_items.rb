class CreateBillItems < ActiveRecord::Migration
  def change
    create_table :bill_items do |t|
      t.decimal :voice
      t.decimal :message
      t.decimal :internet
      t.decimal :service
      t.decimal :proxy
      t.references :bill
      t.references :number ,:foreign_key => true, null:false

      t.timestamps null: false
    end
    add_foreign_key :bill_items, :bills, on_delete: :cascade
  end
end
