module ActiveRecord
  module ConnectionAdapters
    module OracleEnhanced
      module DatabaseStatements
        def sql_for_insert(sql, pk, binds)
          unless pk == false || pk.nil? || pk.is_a?(Array)
            sql = "#{sql} RETURNING #{quote_column_name(pk)} INTO :returning_id"
            (binds = binds.dup) << ActiveRecord::Relation::QueryAttribute.new('returning_id', nil,
                                                                              Type::OracleEnhanced::Integer.new)
          end
          super
        end
      end
    end

    class OracleEnhancedAdapter
      def prefetch_primary_key?(_table_name = nil)
        false
      end
    end
  end
end

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  EPOCH = 1_314_220_021_721
  SHARD_LEN = 13
  SEQ = 'global_id_sequence'
  SEQ_LEN = 10
  PER_SHARD_MSEC = 1024

  before_create -> { self.id = nil }
end
