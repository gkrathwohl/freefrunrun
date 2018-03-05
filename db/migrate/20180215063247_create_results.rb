class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.references :race, foreign_key: true
      t.references :athlete, foreign_key: true
      t.integer :place
      t.datetime :time

      t.timestamps
    end
  end
end
