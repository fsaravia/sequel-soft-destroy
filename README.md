[![Build Status](https://travis-ci.org/fsaravia/sequel-soft-destroy.svg?branch=master)](https://travis-ci.org/fsaravia/sequel-soft-destroy)

# Sequel SoftDestroy plugin

`Sequel::Plugins::SoftDestroy` is a simple and opinionated Sequel plugin that provides soft delete capabilities.

This gem avoids dealing with Sequel internals and relies on models having a `deleted_at` column. When a model is soft deleted, a timestamp will be added to the `deleted_at` field, which marks it as deleted and also stores the UTC time in which the model was deleted. This is useful if any unique constraints have to be observed in your application.

## Usage

```ruby
class Foo < Sequel::Model
  plugin :soft_destroy
end
```

When you want to soft delete a model, just call `soft_destroy` on it:

```ruby
foo = Foo.create(name: "foo")

foo.deleted? #=> false

foo.soft_destroy

foo.deleted? #=> true
```

This library also provides convenience methods to filter out deleted items:

```ruby
foo_1 = Foo.create(name: "foo 2")
foo_2 = Foo.create(name: "foo 1")

foo_1.soft_destroy

Foo[foo_1.id] #=> nil

Foo.filter_deleted.all #=> [foo_2]
```

If you ever need to recover a deleted mode, just call `recover`:

```ruby
foo = Foo.create(name: "foo")

foo.deleted? #=> false

foo.soft_destroy

foo.deleted? #=> true

foo.recover

foo.deleted? #=> false
```
