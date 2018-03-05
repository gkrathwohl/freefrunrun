class ChangeResultTimeToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :results, :time, :integer
  end
end
