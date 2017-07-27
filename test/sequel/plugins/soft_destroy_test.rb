require_relative "../../helper"
require_relative "../../../lib/sequel/plugins/soft_destroy"

class SoftDestroyTest < Minitest::Test
  class Foo < Sequel::Model
    plugin :soft_destroy
  end

  def test_soft_destroy
    foo = Foo.create(name: "foo")

    delete_time = Time.now.utc

    Time.stub :now, delete_time do
      foo.soft_destroy
    end

    assert_equal delete_time.to_i, foo.refresh.deleted_at
  end

  def test_deleted
    foo = Foo.create(name: "foo").soft_destroy

    assert foo.deleted?
  end

  def test_recover
    foo = Foo.create(name: "foo").soft_destroy

    foo.recover
    foo.refresh

    assert_nil foo.deleted_at

    refute foo.deleted?
  end

  def test_filter_deleted
    foo_1 = Foo.create(name: "foo 1")
    foo_2 = Foo.create(name: "foo 2")
    foo_3 = Foo.create(name: "foo 3").soft_destroy
    foo_4 = Foo.create(name: "foo 4").soft_destroy

    assert_equal 4, Foo.where(Sequel.ilike(:name, "foo%")).count

    assert_equal 2, Foo.filter_deleted.where(Sequel.ilike(:name, "foo%")).count

    assert_equal [foo_1, foo_2], Foo.filter_deleted.where(Sequel.ilike(:name, "foo%")).all
  end

  def test_fetch
    foo = Foo.create(name: "foo 1").soft_destroy

    assert_nil Foo[foo.id]
  end
end
