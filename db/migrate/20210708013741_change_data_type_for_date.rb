class ChangeDataTypeForDate < ActiveRecord::Migration[6.1]
  def change
	change_column :locations, :creationdate, :date
  end
end
