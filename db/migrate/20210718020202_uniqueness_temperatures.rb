class UniquenessTemperatures < ActiveRecord::Migration[6.1]
  def change
	add_index :forecasted_temperatures, [:location_id, :date_forecasted], unique: true
  end
end
