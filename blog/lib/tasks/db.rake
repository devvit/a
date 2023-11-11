# tasks

namespace :prj do
  desc 'Database reset'
  task reset: :environment do
    adapter = ActiveRecord::Base.connection.adapter_name.to_sym

    type_json = {
      SQLServer: :json,
      Mysql2: :json,
      OracleEnhanced: :text,
      PostgreSQL: :jsonb
    }[adapter]

    type_string = {
      SQLServer: :string,
      Mysql2: :string,
      OracleEnhanced: :string,
      PostgreSQL: :text
    }[adapter]

    shard_id = 10

    id_gen = lambda {
      begin
        {
          SQLServer: "(cast((DATEDIFF_BIG(MILLISECOND,'1970-01-01 00:00:00.000', SYSUTCDATETIME()) - #{ApplicationRecord::EPOCH}) * power(2, #{ApplicationRecord::SEQ_LEN + ApplicationRecord::SHARD_LEN}) as bigint) | (#{shard_id} * power(2, #{ApplicationRecord::SEQ_LEN}))) | ((next value for #{ApplicationRecord::SEQ}) % #{ApplicationRecord::PER_SHARD_MSEC})",
          Mysql2: "(((cast(UNIX_TIMESTAMP(SYSDATE(3)) * 1000 - #{ApplicationRecord::EPOCH} as unsigned) << #{ApplicationRecord::SEQ_LEN + ApplicationRecord::SHARD_LEN}) | (#{shard_id} << #{ApplicationRecord::SEQ_LEN})) | mod(next value for #{ApplicationRecord::SEQ}, #{ApplicationRecord::PER_SHARD_MSEC}))",
          OracleEnhanced: "bitor(bitor((((sysdate - to_date('01-JAN-1970','DD-MON-YYYY')) * 86400000 + to_number(to_char(systimestamp,'FF3')) - #{ApplicationRecord::EPOCH}) * power(2, #{ApplicationRecord::SEQ_LEN + ApplicationRecord::SHARD_LEN})), #{shard_id} * power(2, #{ApplicationRecord::SEQ_LEN})), MOD(#{ApplicationRecord::SEQ}.nextval, #{ApplicationRecord::PER_SHARD_MSEC}))",
          PostgreSQL: "seq_gen(#{shard_id})"
        }[adapter]
      ensure
        shard_id += 1
      end
    }

    auto_comment = -> { "SHARD-#{shard_id}" }

    ActiveRecord::Schema.define do
      if adapter == :OracleEnhanced
        # https://stackoverflow.com/questions/4820183/ora-00933-sql-command-not-properly-ended
        # https://stackoverflow.com/questions/30044605/what-is-a-good-way-to-do-bitor-in-pl-sql
        # https://stackoverflow.com/questions/10613846/create-table-with-sequence-nextval-in-oracle
        execute <<-SQL
          DECLARE
            sequence_doesnt_exist EXCEPTION;
            PRAGMA EXCEPTION_INIT(sequence_doesnt_exist, -2289);
          BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE #{ApplicationRecord::SEQ}';
          EXCEPTION
            WHEN sequence_doesnt_exist THEN NULL;
          END;
        SQL
        # execute <<-SQL
        #   CREATE OR REPLACE FUNCTION bitor(a IN NUMBER, b IN NUMBER)
        #   RETURN NUMBER
        #   IS
        #   BEGIN
        #     RETURN a + b - bitand(a, b);
        #   END;
        # SQL
      else
        execute "DROP SEQUENCE IF EXISTS #{ApplicationRecord::SEQ}"
      end

      execute "CREATE SEQUENCE #{ApplicationRecord::SEQ} START WITH 1 INCREMENT BY 1"

      if adapter == :PostgreSQL
        execute <<-SQL
          CREATE OR REPLACE FUNCTION seq_gen(shard integer) RETURNS bigint AS $$
            BEGIN
              RETURN (((floor(extract(epoch from clock_timestamp()) * 1000) - #{ApplicationRecord::EPOCH})::bigint << #{ApplicationRecord::SEQ_LEN + ApplicationRecord::SHARD_LEN}) | (shard << #{ApplicationRecord::SEQ_LEN})) | mod(nextval('#{ApplicationRecord::SEQ}'), #{ApplicationRecord::PER_SHARD_MSEC});
            END;
          $$ LANGUAGE plpgsql;
        SQL
      end

      create_table :posts, force: true, comment: auto_comment.call, id: :bigint, primary_key: :id,
                           default: id_gen do |t|
        t.column :title, type_string
      end
    end
  end

  desc 'Database seed'
  task seed: :environment do
  end

  desc 'Database fixtures'
  task fixtures: :environment do
  end
end
