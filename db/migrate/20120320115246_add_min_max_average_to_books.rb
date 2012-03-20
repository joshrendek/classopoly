class AddMinMaxAverageToBooks < ActiveRecord::Migration
  def change
    add_column :books, :min_price, :float
    add_column :books, :max_price, :float
    add_column :books, :average_price, :float
    remove_column :books, :price
  end
end
