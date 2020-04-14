class AddAccessToHathitrustOverlap < ActiveRecord::Migration[5.0]
  def change
    add_column :hathitrust_overlaps, :access, :string
    add_index :hathitrust_overlaps, :access
  end
end
