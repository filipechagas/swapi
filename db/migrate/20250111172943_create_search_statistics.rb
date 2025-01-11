class CreateSearchStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :search_statistics do |t|
      t.string :query
      t.string :search_type
      t.float :response_time

      t.timestamps
    end
  end
end
