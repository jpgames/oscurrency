class AddRespondByDateToReqs < ActiveRecord::Migration
  def change
    add_column :reqs, :respond_by_date, :datetime
  end
end
