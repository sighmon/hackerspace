class AddPaypalDetailsToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :paypal_payer_id, :string
    add_column :memberships, :paypal_email, :string
    add_column :memberships, :paypal_first_name, :string
    add_column :memberships, :paypal_last_name, :string
    add_column :memberships, :paypal_profile_id, :string
    add_column :memberships, :paypal_street1, :string
    add_column :memberships, :paypal_street2, :string
    add_column :memberships, :paypal_city_name, :string
    add_column :memberships, :paypal_state_or_province, :string
    add_column :memberships, :paypal_country_name, :string
    add_column :memberships, :paypal_country_code, :string
    add_column :memberships, :paypal_postal_code, :string
    add_column :memberships, :price_paid, :integer
    add_column :memberships, :concession, :boolean
  end
end
