class AddLatitude < ActiveRecord::Migration
  def change

    add_column :tickets, :lat, :float
    add_column :tickets, :long, :float
    add_column :tickets, :city, :string
    add_column :tickets, :raw_address, :string
  end

end
