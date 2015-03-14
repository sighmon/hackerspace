class AddNfcAtrAndNfcIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nfc_atr, :binary
    add_column :users, :nfc_id, :binary
  end
end
