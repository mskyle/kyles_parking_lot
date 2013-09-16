class AddParkedOn < ActiveRecord::Migration
  def change
    add_column :registrations, :parked_on, :date, null: false
  end
end
