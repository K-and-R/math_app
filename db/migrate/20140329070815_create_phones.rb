class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :user, index: true
      t.string :number
      t.references :phone_type, index: true

      t.timestamps
    end
  end
end
