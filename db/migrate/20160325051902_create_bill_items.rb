class CreateBillItems < ActiveRecord::Migration
  def change
    create_table :bill_items do |t|
      t.decimal :voice, precision: 10, scale: 2
      t.decimal :message, precision: 10, scale: 2
      t.decimal :internet, precision: 10, scale: 2
      t.decimal :service, precision: 10, scale: 2
      t.decimal :proxy, precision: 10, scale: 2
      t.references :bill, precision: 10, scale: 2
      t.references :number ,:foreign_key => true, null:false

      t.timestamps null: false
    end
    add_foreign_key :bill_items, :bills, on_delete: :cascade
  end
end
