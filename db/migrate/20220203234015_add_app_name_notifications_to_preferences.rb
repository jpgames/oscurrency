class AddAppNameNotificationsToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :app_name_notifications, :string, :default => ""
  end
end
