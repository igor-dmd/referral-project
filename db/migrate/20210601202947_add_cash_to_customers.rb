class AddCashToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :cash, :float
  end
end
