class AddWebsiteAndAboutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website, :text
    add_column :users, :about, :text
  end
end
