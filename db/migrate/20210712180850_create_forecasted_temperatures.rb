class CreateForecastedTemperatures < ActiveRecord::Migration[6.1]
  def change
    create_table :forecasted_temperatures do |t|
		t.date :date_forecasted
		t.integer :min_forecasted
		t.integer :max_forecasted
		t.integer :location_id
      	t.timestamps
    end
  end
end
