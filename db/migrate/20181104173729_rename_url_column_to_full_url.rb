class RenameUrlColumnToFullUrl < ActiveRecord::Migration[5.2]
  def change
    rename_column :urls, :url, :full_url
  end
end
