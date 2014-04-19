class AddAlertAddressToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :alert_method, :string, default: 'ignore'
  end
end
