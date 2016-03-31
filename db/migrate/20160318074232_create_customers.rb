class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :linkman
      t.string :phone
      t.string :address
      t.text :remark

      t.timestamps null: false
    end
  end
end
