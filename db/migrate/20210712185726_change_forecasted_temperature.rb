class ChangeForecastedTemperature < ActiveRecord::Migration[6.1]
  def change
	remove_column :forecasted_temperatures, :location_id, :integer
	add_column :forecasted_temperatures, :location_slug, :string
  end
end
