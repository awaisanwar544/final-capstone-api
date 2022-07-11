class CreateJoinTableProviderSkill < ActiveRecord::Migration[7.0]
  def change
    create_join_table :providers, :skills do |t|
      # t.index [:provider_id, :skill_id]
      # t.index [:skill_id, :provider_id]
    end
  end
end
