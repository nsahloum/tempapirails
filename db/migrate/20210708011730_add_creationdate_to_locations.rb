class AddCreationdateToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :creationdate, :datetime
  end
end
