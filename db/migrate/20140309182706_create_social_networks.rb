class CreateSocialNetworks < ActiveRecord::Migration
  def change
    create_table :social_networks do |t|
      t.string :short_name, :limit => 64 
      t.string :name, :limit => 255

      t.timestamps
    end
    add_index(:social_networks, [ :short_name ], :unique => true)
  end
end
