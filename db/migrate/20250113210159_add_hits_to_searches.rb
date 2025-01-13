class AddHitsToSearches < ActiveRecord::Migration[8.0]
  def change
    add_column :searches, :hits, :integer, default: 1
  end
end
