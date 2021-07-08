class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
		t.float :latitude
      	t.float :longitude
      	t.string :slug
    end
  end
end
