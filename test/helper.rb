require "sequel"
require "minitest/autorun"

DB = Sequel.sqlite

DB.create_table(:foos) do
  primary_key :id

  column :name,       :text
  column :deleted_at, :integer
end

class SoftDestroyTest < Minitest::Test
  def run
    Sequel::Model.db.transaction(rollback: :always, auto_savepoint: true) do
      super
    end
  end
end
