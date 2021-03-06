class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.json :auth_config, null: false, default: '{}'
      t.timestamps
    end
  end
end
