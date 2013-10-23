class AddRefundAndCancellationDateToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :refund, :integer
    add_column :memberships, :cancellation_date, :datetime
  end
end
