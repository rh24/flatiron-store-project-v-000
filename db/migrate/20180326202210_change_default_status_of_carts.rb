class ChangeDefaultStatusOfCarts < ActiveRecord::Migration
  def change
    change_column :carts, :status, :string, :default => 'not submitted'
  end
end
