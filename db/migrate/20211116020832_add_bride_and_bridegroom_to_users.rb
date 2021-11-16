class AddBrideAndBridegroomToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :bride, :string
    add_column :users, :bridegroom, :string
  end
end
