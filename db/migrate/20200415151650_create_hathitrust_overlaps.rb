class CreateHathitrustOverlaps < ActiveRecord::Migration[5.0]
  def change
    create_table :hathitrust_overlaps do |t|
      t.string :oclc_number
      t.string :bib_id

      t.timestamps
    end
    add_index :hathitrust_overlaps, :bib_id
  end
end
