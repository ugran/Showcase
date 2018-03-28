class AddStatusToPersonalInformation < ActiveRecord::Migration[5.2]
  def change
    add_column :personal_informations, :status, :boolean
  end
end
