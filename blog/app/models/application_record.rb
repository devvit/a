class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  EPOCH = 1_314_220_021_721
  SHARD_LEN = 13
  SEQ = 'global_id_sequence'
  SEQ_LEN = 10
  PER_SHARD_MSEC = 1024

  before_create -> { self.id = nil }
end
