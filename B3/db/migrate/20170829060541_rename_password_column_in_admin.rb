class RenamePasswordColumnInAdmin < ActiveRecord::Migration[5.1]
  def change
  	rename_column :admins, :password,:password_digest
  end
end
