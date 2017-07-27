require "sequel"

module Sequel
  module Plugins
    module SoftDestroy
      DELETED_AT_COLUMN = :deleted_at

      module ClassMethods
        Sequel::Plugins.def_dataset_methods(self, :filter_deleted)

        def [](*args)
          model = super

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
