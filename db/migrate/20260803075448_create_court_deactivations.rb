class CreateCourtDeactivations < ActiveRecord::Migration[8.1]
  def change
    create_table :court_deactivations do |t|
      t.references :court, null: false, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
