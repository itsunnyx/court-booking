class AddCreditToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :credit, :integer, default: 0
  end
end
