class AddMapsUrlToTickets < ActiveRecord::Migration
  def change
        add_column :tickets, :mapURL, :string
  end
end
