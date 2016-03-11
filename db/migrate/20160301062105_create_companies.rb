class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :bill_number
      t.string :tel_office
      t.date :apply_at

      t.timestamps null: false
    end
  end
end
