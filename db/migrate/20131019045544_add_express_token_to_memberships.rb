class AddExpressTokenToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :express_token, :string
    add_column :memberships, :express_payer_id, :string
  end
end
