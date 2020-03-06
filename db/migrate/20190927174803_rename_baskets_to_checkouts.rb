class RenameBasketsToCheckouts < ActiveRecord::Migration[5.2]
  def change
    rename_table :baskets, :checkouts
  end
end
