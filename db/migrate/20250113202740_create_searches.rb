class CreateSearches < ActiveRecord::Migration[8.0]
  def change
    create_table :searches do |t|
      t.string :search_type
      t.string :query
      t.integer :page
      t.json :results
      t.float :response_time
      t.datetime :expires_at

      t.timestamps
    end
  end
end
