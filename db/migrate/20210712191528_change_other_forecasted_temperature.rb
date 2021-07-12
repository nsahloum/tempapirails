class ChangeOtherForecastedTemperature < ActiveRecord::Migration[6.1]
  def change
	add_column :forecasted_temperatures, :location_id, :integer
	remove_column :forecasted_temperatures, :location_slug, :string
  end
end
