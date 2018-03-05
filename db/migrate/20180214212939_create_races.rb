class CreateRaces < ActiveRecord::Migration[5.1]
  def change
    create_table :races do |t|
      t.string :name
      t.date :start_datetime

      t.timestamps
    end
  end
end
