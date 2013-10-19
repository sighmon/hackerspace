class AddPurchaseDateToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :purchase_date, :datetime
  end
end
