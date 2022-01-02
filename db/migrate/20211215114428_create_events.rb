class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :summary
      t.text :description
      t.string :eid
      t.string :status
      t.string :organizer
      t.datetime :from_time
      t.datetime :to_time
      t.references :user

      t.timestamps
    end
  end
end
