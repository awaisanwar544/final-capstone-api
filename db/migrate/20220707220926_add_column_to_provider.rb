class AddColumnToProvider < ActiveRecord::Migration[7.0]
  def change
    add_column :providers, :github_profile, :string
    add_column :providers, :linkedin_profile, :string
    add_column :providers, :twitter_profile, :string
  end
end
