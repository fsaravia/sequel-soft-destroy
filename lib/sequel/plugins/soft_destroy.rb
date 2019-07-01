require "sequel"

module Sequel
  module Plugins
    module SoftDestroy
      DELETED_AT_COLUMN = :deleted_at

      module ClassMethods
        Sequel::Plugins.def_dataset_methods(self, :filter_deleted)

        def [](*args)
          args = args.first if args.size <= 1

          return filter_deleted.first(args) if args.is_a?(Hash)

          return if args.nil?

          model = primary_key_lookup(args)

          return if model.nil? || model.deleted?

          model
        end
      end

      module DatasetMethods
        def filter_deleted
          where(DELETED_AT_COLUMN => nil)
        end
      end

      module InstanceMethods
        def soft_destroy
          update(DELETED_AT_COLUMN => Time.now.utc)
        end

        def recover
          update(DELETED_AT_COLUMN => nil)
        end

        def deleted?
          !values[DELETED_AT_COLUMN].nil?
        end
      end
    end
  end
end
