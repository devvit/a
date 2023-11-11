# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_10_141732) do
  create_table "aq$_internet_agent_privs", id: false, force: :cascade do |t|
    t.string "agent_name", limit: 30, null: false
    t.string "db_username", limit: 30, null: false
    t.index ["agent_name", "db_username"], name: "unq_pairs", unique: true
  end

  create_table "aq$_internet_agents", primary_key: "agent_name", id: { type: :string, limit: 30 }, force: :cascade do |t|
    t.integer "protocol", precision: 38, null: false
    t.string "spare1", limit: 128
  end

  create_table "aq$_queue_tables", primary_key: "objno", id: :decimal, force: :cascade do |t|
    t.string "schema", limit: 30, null: false
    t.string "name", limit: 30, null: false
    t.decimal "udata_type", null: false
    t.decimal "flags", null: false
    t.decimal "sort_cols", null: false
    t.string "timezone", limit: 64
    t.string "table_comment", limit: 2000
    t.index ["objno", "schema", "flags"], name: "i1_queue_tables"
  end

# Could not dump table "aq$_queues" because of following StandardError
#   Unknown type 'SYS.AQ$_SUBSCRIBERS' for column 'subscribers'

  create_table "aq$_schedules", primary_key: ["oid", "destination"], force: :cascade do |t|
    t.raw "oid", limit: 16, null: false
    t.string "destination", limit: 128, null: false
    t.date "start_time"
    t.string "duration", limit: 8
    t.string "next_time", limit: 128
    t.string "latency", limit: 8
    t.date "last_time"
    t.decimal "jobno"
    t.index ["jobno"], name: "aq$_schedules_check", unique: true
  end

  create_table "def$_aqcall", primary_key: ["enq_tid", "step_no"], force: :cascade do |t|
    t.string "q_name", limit: 30
    t.raw "msgid", limit: 16
    t.string "corrid", limit: 128
    t.decimal "priority"
    t.decimal "state"
    t.datetime "delay"
    t.decimal "expiration"
    t.datetime "time_manager_info"
    t.decimal "local_order_no"
    t.decimal "chain_no"
    t.decimal "cscn"
    t.decimal "dscn"
    t.datetime "enq_time"
    t.decimal "enq_uid"
    t.string "enq_tid", limit: 30, null: false
    t.datetime "deq_time"
    t.decimal "deq_uid"
    t.string "deq_tid", limit: 30
    t.decimal "retry_count"
    t.string "exception_qschema", limit: 30
    t.string "exception_queue", limit: 30
    t.decimal "step_no", null: false
    t.decimal "recipient_key"
    t.raw "dequeue_msgid", limit: 16
    t.binary "user_data"
    t.index ["cscn", "enq_tid"], name: "def$_tranorder"
  end

  create_table "def$_aqerror", primary_key: ["enq_tid", "step_no"], force: :cascade do |t|
    t.string "q_name", limit: 30
    t.raw "msgid", limit: 16
    t.string "corrid", limit: 128
    t.decimal "priority"
    t.decimal "state"
    t.datetime "delay"
    t.decimal "expiration"
    t.datetime "time_manager_info"
    t.decimal "local_order_no"
    t.decimal "chain_no"
    t.decimal "cscn"
    t.decimal "dscn"
    t.datetime "enq_time"
    t.decimal "enq_uid"
    t.string "enq_tid", limit: 30, null: false
    t.datetime "deq_time"
    t.decimal "deq_uid"
    t.string "deq_tid", limit: 30
    t.decimal "retry_count"
    t.string "exception_qschema", limit: 30
    t.string "exception_queue", limit: 30
    t.decimal "step_no", null: false
    t.decimal "recipient_key"
    t.raw "dequeue_msgid", limit: 16
    t.binary "user_data"
  end

  create_table "def$_calldest", primary_key: ["enq_tid", "dblink", "step_no"], comment: "Information about call destinations for D-type and error transactions", force: :cascade do |t|
    t.string "enq_tid", limit: 22, null: false, comment: "Transaction ID"
    t.decimal "step_no", null: false, comment: "Unique ID of call within transaction"
    t.string "dblink", limit: 128, null: false, comment: "The destination database"
    t.string "schema_name", limit: 30, comment: "The schema of the deferred remote procedure call"
    t.string "package_name", limit: 30, comment: "The package of the deferred remote procedure call"
    t.raw "catchup", limit: 16, default: "00", comment: "Dummy column for foreign key"
    t.index ["dblink", "catchup"], name: "def$_calldest_n2"
  end

  create_table "def$_defaultdest", primary_key: "dblink", id: { type: :string, limit: 128, comment: "Default destination" }, comment: "Default destinations for deferred remote procedure calls", force: :cascade do |t|
  end

  create_table "def$_destination", primary_key: ["dblink", "catchup"], comment: "Information about propagation to different destinations", force: :cascade do |t|
    t.string "dblink", limit: 128, null: false, comment: "Destination"
    t.decimal "last_delivered", default: "0.0", null: false, comment: "Value of delivery_order of last transaction propagated"
    t.string "last_enq_tid", limit: 22, comment: "Transaction ID of last transaction propagated"
    t.decimal "last_seq", comment: "Parallel prop seq number of last transaction propagated"
    t.string "disabled", limit: 1, comment: "Is propagation to destination disabled"
    t.decimal "job", comment: "Number of job that pushes queue"
    t.decimal "last_txn_count", comment: "Number of transactions pushed during last attempt"
    t.decimal "last_error_number", comment: "Oracle error number from last push"
    t.string "last_error_message", limit: 2000, comment: "Error message from last push"
    t.string "apply_init", limit: 4000
    t.raw "catchup", limit: 16, default: "00", null: false, comment: "Used to break transaction into pieces"
    t.string "alternate", limit: 1, default: "F", comment: "Used to break transaction into pieces"
    t.decimal "total_txn_count", default: "0.0", comment: "Total number of transactions pushed"
    t.decimal "total_prop_time_throughput", default: "0.0", comment: "Total propagation time in seconds for measuring throughput"
    t.decimal "total_prop_time_latency", default: "0.0", comment: "Total propagation time in seconds for measuring latency"
    t.decimal "to_communication_size", default: "0.0", comment: "Total number of bytes sent to this dblink"
    t.decimal "from_communication_size", default: "0.0", comment: "Total number of bytes received from this dblink"
    t.raw "flag", limit: 4, default: "00000000"
    t.decimal "spare1", default: "0.0", comment: "Total number of round trips for this dblink"
    t.decimal "spare2", default: "0.0", comment: "Total number of administrative requests"
    t.decimal "spare3", default: "0.0", comment: "Total number of error transactions pushed"
    t.decimal "spare4", default: "0.0", comment: "Total time in seconds spent sleeping during push"
  end

  create_table "def$_error", primary_key: "enq_tid", id: { type: :string, limit: 22, comment: "The ID of the transaction that created the error" }, comment: "Information about all deferred transactions that caused an error", force: :cascade do |t|
    t.string "origin_tran_db", limit: 128, comment: "The database originating the deferred transaction"
    t.string "origin_enq_tid", limit: 22, comment: "The original ID of the transaction"
    t.string "destination", limit: 128, comment: "Database link used to address destination"
    t.decimal "step_no", comment: "Unique ID of call that caused an error"
    t.decimal "receiver", comment: "User ID of the original receiver"
    t.date "enq_time", comment: "Time original transaction enqueued"
    t.decimal "error_number", comment: "Oracle error number"
    t.string "error_msg", limit: 2000, comment: "Error message text"
  end

  create_table "def$_lob", id: { type: :raw, limit: 16, comment: "Identifier of LOB parameter" }, comment: "Storage for LOB parameters to deferred RPCs", force: :cascade do |t|
    t.string "enq_tid", limit: 22, comment: "Transaction identifier for deferred RPC with this LOB parameter"
    t.binary "blob_col", comment: "Binary LOB parameter"
    t.text "clob_col", comment: "Character LOB parameter"
    t.ntext "nclob_col", comment: "National Character LOB parameter"
    t.index ["enq_tid"], name: "def$_lob_n1"
  end

  create_table "def$_origin", id: false, comment: "Information about deferred transactions pushed to this site", force: :cascade do |t|
    t.string "origin_db", limit: 128, comment: "Originating database for the deferred transaction"
    t.string "origin_dblink", limit: 128, comment: "Database link from deferred transaction origin to this site"
    t.decimal "inusr", comment: "Connected user receiving the deferred transaction"
    t.decimal "cscn", comment: "Prepare SCN assigned at origin site"
    t.string "enq_tid", limit: 22, comment: "Transaction id assigned at origin site"
    t.decimal "reco_seq_no", comment: "Deferred transaction sequence number for recovery"
    t.raw "catchup", limit: 16, default: "00", comment: "Used to break transaction into pieces"
  end

  create_table "def$_propagator", primary_key: "userid", id: { type: :decimal, comment: "User ID of the propagator" }, comment: "The propagator for deferred remote procedure calls", force: :cascade do |t|
    t.string "username", limit: 30, null: false, comment: "User name of the propagator"
    t.date "created", null: false, comment: "The time when the propagator is registered"
  end

  create_table "def$_pushed_transactions", primary_key: "source_site_id", id: { type: :decimal, comment: "Originating database identifier for the deferred transaction" }, comment: "Information about deferred transactions pushed to this site by RepAPI clients", force: :cascade do |t|
    t.decimal "last_tran_id", default: "0.0", comment: "Last committed transaction"
    t.string "disabled", limit: 1, default: "F", comment: "Disable propagation"
    t.string "source_site", limit: 128, comment: "Obsolete - do not use"
  end

  create_table "help", primary_key: ["topic", "seq"], force: :cascade do |t|
    t.string "topic", limit: 50, null: false
    t.decimal "seq", null: false
    t.string "info", limit: 80
  end

  create_table "logmnr_age_spill$", primary_key: ["session#", "xidusn", "xidslt", "xidsqn", "chunk", "sequence#"], force: :cascade do |t|
    t.decimal "session#", null: false
    t.decimal "xidusn", null: false
    t.decimal "xidslt", null: false
    t.decimal "xidsqn", null: false
    t.decimal "chunk", null: false
    t.decimal "sequence#", null: false
    t.decimal "offset"
    t.binary "spill_data"
    t.decimal "spare1"
    t.decimal "spare2"
  end

  create_table "logmnr_attrcol$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.decimal "intcol#"
    t.string "name", limit: 4000
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1attrcol$"
  end

  create_table "logmnr_attribute$", primary_key: ["logmnr_uid", "toid", "version#", "attribute#"], force: :cascade do |t|
    t.decimal "version#"
    t.string "name", limit: 30
    t.decimal "attribute#"
    t.raw "attr_toid", limit: 16
    t.decimal "attr_version#"
    t.decimal "synobj#"
    t.decimal "properties"
    t.decimal "charsetid"
    t.decimal "charsetform"
    t.decimal "length"
    t.decimal "precision#"
    t.decimal "scale"
    t.string "externname", limit: 4000
    t.decimal "xflags"
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.decimal "spare4"
    t.decimal "spare5"
    t.decimal "setter"
    t.decimal "getter"
    t.raw "toid", limit: 16, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "toid", "version#", "attribute#"], name: "logmnr_i1attribute$"
  end

  create_table "logmnr_ccol$", primary_key: ["logmnr_uid", "con#", "intcol#"], force: :cascade do |t|
    t.decimal "con#"
    t.decimal "obj#"
    t.decimal "col#"
    t.decimal "pos#"
    t.decimal "intcol#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "con#", "intcol#"], name: "logmnr_i1ccol$"
  end

  create_table "logmnr_cdef$", primary_key: ["logmnr_uid", "con#"], force: :cascade do |t|
    t.decimal "con#"
    t.decimal "cols"
    t.decimal "type#"
    t.decimal "robj#"
    t.decimal "rcon#"
    t.decimal "enabled"
    t.decimal "defer"
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "con#"], name: "logmnr_i1cdef$"
  end

  create_table "logmnr_col$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.integer "col#", limit: 22, precision: 22
    t.integer "segcol#", limit: 22, precision: 22
    t.string "name", limit: 30
    t.integer "type#", limit: 22, precision: 22
    t.integer "length", limit: 22, precision: 22
    t.integer "precision#", limit: 22, precision: 22
    t.integer "scale", limit: 22, precision: 22
    t.integer "null$", limit: 22, precision: 22
    t.integer "intcol#", limit: 22, precision: 22
    t.integer "property", limit: 22, precision: 22
    t.integer "charsetid", limit: 22, precision: 22
    t.integer "charsetform", limit: 22, precision: 22
    t.integer "spare1", limit: 22, precision: 22
    t.integer "spare2", limit: 22, precision: 22
    t.integer "obj#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "col#"], name: "logmnr_i3col$"
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1col$"
    t.index ["logmnr_uid", "obj#", "name"], name: "logmnr_i2col$"
  end

  create_table "logmnr_coltype$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.decimal "col#"
    t.decimal "intcol#"
    t.raw "toid", limit: 16
    t.decimal "version#"
    t.decimal "packed"
    t.decimal "intcols"
    t.raw "intcol#s"
    t.decimal "flags"
    t.decimal "typidcol#"
    t.decimal "synobj#"
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1coltype$"
  end

  create_table "logmnr_dictionary$", primary_key: "logmnr_uid", id: { limit: 22, precision: 22 }, force: :cascade do |t|
    t.string "db_name", limit: 9
    t.integer "db_id", limit: 20, precision: 20
    t.string "db_created", limit: 20
    t.string "db_dict_created", limit: 20
    t.integer "db_dict_scn", limit: 22, precision: 22
    t.raw "db_thread_map", limit: 8
    t.integer "db_txn_scnbas", limit: 22, precision: 22
    t.integer "db_txn_scnwrp", limit: 22, precision: 22
    t.integer "db_resetlogs_change#", limit: 22, precision: 22
    t.string "db_resetlogs_time", limit: 20
    t.string "db_version_time", limit: 20
    t.string "db_redo_type_id", limit: 8
    t.string "db_redo_release", limit: 60
    t.string "db_character_set", limit: 30
    t.string "db_version", limit: 64
    t.string "db_status", limit: 64
    t.string "db_global_name", limit: 128
    t.integer "db_dict_maxobjects", limit: 22, precision: 22
    t.integer "db_dict_objectcount", limit: 22, precision: 22, null: false
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid"], name: "logmnr_i1dictionary$"
  end

  create_table "logmnr_dictstate$", primary_key: "logmnr_uid", id: { limit: 22, precision: 22 }, force: :cascade do |t|
    t.decimal "start_scnbas"
    t.decimal "start_scnwrp"
    t.decimal "end_scnbas"
    t.decimal "end_scnwrp"
    t.decimal "redo_thread"
    t.decimal "rbasqn"
    t.decimal "rbablk"
    t.decimal "rbabyte"
    t.integer "logmnr_flags", limit: 22, precision: 22
  end

  create_table "logmnr_enc$", primary_key: ["logmnr_uid", "obj#", "owner#"], force: :cascade do |t|
    t.decimal "obj#"
    t.decimal "owner#"
    t.decimal "encalg"
    t.decimal "intalg"
    t.raw "colklc"
    t.decimal "klclen"
    t.decimal "flag"
    t.string "mkeyid", limit: 64, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "owner#"], name: "logmnr_i1enc$"
  end

  create_table "logmnr_error$", id: false, force: :cascade do |t|
    t.decimal "session#"
    t.date "time_of_error"
    t.decimal "code"
    t.string "message", limit: 4000
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.string "spare4", limit: 4000
    t.string "spare5", limit: 4000
  end

  create_table "logmnr_filter$", id: false, force: :cascade do |t|
    t.decimal "session#"
    t.string "filter_type", limit: 30
    t.decimal "attr1"
    t.decimal "attr2"
    t.decimal "attr3"
    t.decimal "attr4"
    t.decimal "attr5"
    t.decimal "attr6"
    t.decimal "filter_scn"
    t.decimal "spare1"
    t.decimal "spare2"
    t.date "spare3"
  end

  create_table "logmnr_global$", id: false, force: :cascade do |t|
    t.decimal "high_recid_foreign"
    t.decimal "high_recid_deleted"
    t.decimal "local_reset_scn"
    t.decimal "local_reset_timestamp"
    t.decimal "version_timestamp"
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.string "spare4", limit: 2000
    t.date "spare5"
  end

  create_table "logmnr_gt_tab_include$", temporary: true, id: false, force: :cascade do |t|
    t.string "schema_name", limit: 32
    t.string "table_name", limit: 32
  end

  create_table "logmnr_gt_user_include$", temporary: true, id: false, force: :cascade do |t|
    t.string "user_name", limit: 32
    t.decimal "user_type"
  end

  create_table "logmnr_gt_xid_include$", temporary: true, id: false, force: :cascade do |t|
    t.decimal "xidusn"
    t.decimal "xidslt"
    t.decimal "xidsqn"
  end

  create_table "logmnr_icol$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.decimal "obj#"
    t.decimal "bo#"
    t.decimal "col#"
    t.decimal "pos#"
    t.decimal "segcol#"
    t.decimal "intcol#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1icol$"
  end

  create_table "logmnr_ind$", primary_key: ["logmnr_uid", "obj#"], force: :cascade do |t|
    t.integer "bo#", limit: 22, precision: 22
    t.integer "cols", limit: 22, precision: 22
    t.integer "type#", limit: 22, precision: 22
    t.decimal "flags"
    t.decimal "property"
    t.integer "obj#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "bo#"], name: "logmnr_i2ind$"
    t.index ["logmnr_uid", "obj#"], name: "logmnr_i1ind$"
  end

  create_table "logmnr_indcompart$", primary_key: ["logmnr_uid", "obj#"], force: :cascade do |t|
    t.decimal "obj#"
    t.decimal "dataobj#"
    t.decimal "bo#"
    t.decimal "part#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#"], name: "logmnr_i1indcompart$"
  end

  create_table "logmnr_indpart$", primary_key: ["logmnr_uid", "obj#", "bo#"], force: :cascade do |t|
    t.decimal "obj#"
    t.decimal "bo#"
    t.decimal "part#"
    t.decimal "ts#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "bo#"], name: "logmnr_i2indpart$"
    t.index ["logmnr_uid", "obj#", "bo#"], name: "logmnr_i1indpart$"
  end

  create_table "logmnr_indsubpart$", primary_key: ["logmnr_uid", "obj#", "pobj#"], force: :cascade do |t|
    t.integer "obj#", limit: 22, precision: 22
    t.integer "dataobj#", limit: 22, precision: 22
    t.integer "pobj#", limit: 22, precision: 22
    t.integer "subpart#", limit: 22, precision: 22
    t.integer "ts#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "pobj#"], name: "logmnr_i1indsubpart$"
  end

  create_table "logmnr_integrated_spill$", primary_key: ["session#", "xidusn", "xidslt", "xidsqn", "chunk", "flag"], force: :cascade do |t|
    t.decimal "session#", null: false
    t.decimal "xidusn", null: false
    t.decimal "xidslt", null: false
    t.decimal "xidsqn", null: false
    t.decimal "chunk", null: false
    t.decimal "flag", null: false
    t.date "ctime"
    t.date "mtime"
    t.binary "spill_data"
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.date "spare4"
    t.date "spare5"
  end

  create_table "logmnr_kopm$", primary_key: ["logmnr_uid", "name"], force: :cascade do |t|
    t.decimal "length"
    t.raw "metadata", limit: 255
    t.string "name", limit: 30, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "name"], name: "logmnr_i1kopm$"
  end

  create_table "logmnr_lob$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.decimal "obj#"
    t.decimal "intcol#"
    t.decimal "col#"
    t.decimal "lobj#"
    t.decimal "chunk", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1lob$"
  end

  create_table "logmnr_lobfrag$", primary_key: ["logmnr_uid", "fragobj#"], force: :cascade do |t|
    t.decimal "fragobj#"
    t.decimal "parentobj#"
    t.decimal "tabfragobj#"
    t.decimal "indfragobj#"
    t.decimal "frag#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "fragobj#"], name: "logmnr_i1lobfrag$"
  end

  create_table "logmnr_log$", primary_key: ["session#", "thread#", "sequence#", "first_change#", "db_id", "resetlogs_change#", "reset_timestamp"], force: :cascade do |t|
    t.decimal "session#", null: false
    t.decimal "thread#", null: false
    t.decimal "sequence#", null: false
    t.decimal "first_change#", null: false
    t.decimal "next_change#"
    t.date "first_time"
    t.date "next_time"
    t.string "file_name", limit: 513
    t.decimal "status"
    t.string "info", limit: 32
    t.date "timestamp"
    t.string "dict_begin", limit: 3
    t.string "dict_end", limit: 3
    t.string "status_info", limit: 32
    t.decimal "db_id", null: false
    t.decimal "resetlogs_change#", null: false
    t.decimal "reset_timestamp", null: false
    t.decimal "prev_resetlogs_change#"
    t.decimal "prev_reset_timestamp"
    t.decimal "blocks"
    t.decimal "block_size"
    t.decimal "flags"
    t.decimal "contents"
    t.decimal "recid"
    t.decimal "recstamp"
    t.decimal "mark_delete_timestamp"
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.decimal "spare4"
    t.decimal "spare5"
    t.index ["first_change#"], name: "logmnr_log$_first_change#", tablespace: "sysaux"
    t.index ["flags"], name: "logmnr_log$_flags", tablespace: "sysaux"
    t.index ["recid"], name: "logmnr_log$_recid", tablespace: "sysaux"
  end

  create_table "logmnr_logmnr_buildlog", primary_key: ["logmnr_uid", "initial_xid"], force: :cascade do |t|
    t.string "build_date", limit: 20
    t.decimal "db_txn_scnbas"
    t.decimal "db_txn_scnwrp"
    t.decimal "current_build_state"
    t.decimal "completion_status"
    t.decimal "marked_log_file_low_scn"
    t.string "initial_xid", limit: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "initial_xid"], name: "logmnr_i1logmnr_buildlog"
  end

  create_table "logmnr_ntab$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.decimal "col#"
    t.decimal "intcol#"
    t.decimal "ntab#"
    t.string "name", limit: 4000
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "ntab#"], name: "logmnr_i2ntab$"
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1ntab$"
  end

  create_table "logmnr_obj$", primary_key: ["logmnr_uid", "obj#"], force: :cascade do |t|
    t.integer "objv#", limit: 22, precision: 22
    t.integer "owner#", limit: 22, precision: 22
    t.string "name", limit: 30
    t.integer "namespace", limit: 22, precision: 22
    t.string "subname", limit: 30
    t.integer "type#", limit: 22, precision: 22
    t.raw "oid$", limit: 16
    t.string "remoteowner", limit: 30
    t.string "linkname", limit: 128
    t.integer "flags", limit: 22, precision: 22
    t.integer "spare3", limit: 22, precision: 22
    t.date "stime"
    t.integer "obj#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.decimal "start_scnbas"
    t.decimal "start_scnwrp"
    t.index ["logmnr_uid", "obj#"], name: "logmnr_i1obj$"
    t.index ["logmnr_uid", "oid$"], name: "logmnr_i2obj$"
  end

  create_table "logmnr_opqtype$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.decimal "intcol#", null: false
    t.decimal "type"
    t.decimal "flags"
    t.decimal "lobcol"
    t.decimal "objcol"
    t.decimal "extracol"
    t.raw "schemaoid", limit: 16
    t.decimal "elemnum"
    t.string "schemaurl", limit: 4000
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1opqtype$"
  end

  create_table "logmnr_parameter$", id: false, force: :cascade do |t|
    t.decimal "session#", null: false
    t.string "name", limit: 30, null: false
    t.string "value", limit: 2000
    t.decimal "type"
    t.decimal "scn"
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
    t.index ["session#", "name"], name: "logmnr_parameter_indx"
  end

  create_table "logmnr_partobj$", primary_key: ["logmnr_uid", "obj#"], force: :cascade do |t|
    t.decimal "parttype"
    t.decimal "partcnt"
    t.decimal "partkeycols"
    t.decimal "flags"
    t.decimal "defts#"
    t.decimal "defpctfree"
    t.decimal "defpctused"
    t.decimal "defpctthres"
    t.decimal "definitrans"
    t.decimal "defmaxtrans"
    t.decimal "deftiniexts"
    t.decimal "defextsize"
    t.decimal "defminexts"
    t.decimal "defmaxexts"
    t.decimal "defextpct"
    t.decimal "deflists"
    t.decimal "defgroups"
    t.decimal "deflogging"
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.decimal "definclcol"
    t.string "parameters", limit: 1000
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#"], name: "logmnr_i1partobj$"
  end

  create_table "logmnr_processed_log$", primary_key: ["session#", "thread#"], force: :cascade do |t|
    t.decimal "session#", null: false
    t.decimal "thread#", null: false
    t.decimal "sequence#"
    t.decimal "first_change#"
    t.decimal "next_change#"
    t.date "first_time"
    t.date "next_time"
    t.string "file_name", limit: 513
    t.decimal "status"
    t.string "info", limit: 32
    t.date "timestamp"
  end

  create_table "logmnr_props$", primary_key: ["logmnr_uid", "name"], force: :cascade do |t|
    t.string "value$", limit: 4000
    t.string "comment$", limit: 4000
    t.string "name", limit: 30, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "name"], name: "logmnr_i1props$"
  end

  create_table "logmnr_refcon$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.decimal "col#"
    t.decimal "intcol#"
    t.decimal "reftyp"
    t.raw "stabid", limit: 16
    t.raw "expctoid", limit: 16
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1refcon$"
  end

  create_table "logmnr_restart_ckpt$", primary_key: ["session#", "ckpt_scn", "xidusn", "xidslt", "xidsqn", "session_num", "serial_num"], force: :cascade do |t|
    t.decimal "session#", null: false
    t.decimal "valid"
    t.decimal "ckpt_scn", null: false
    t.decimal "xidusn", null: false
    t.decimal "xidslt", null: false
    t.decimal "xidsqn", null: false
    t.decimal "session_num", null: false
    t.decimal "serial_num", null: false
    t.binary "ckpt_info"
    t.decimal "flag"
    t.decimal "offset"
    t.binary "client_data"
    t.decimal "spare1"
    t.decimal "spare2"
  end

  create_table "logmnr_restart_ckpt_txinfo$", primary_key: ["session#", "xidusn", "xidslt", "xidsqn", "session_num", "serial_num", "effective_scn"], force: :cascade do |t|
    t.decimal "session#", null: false
    t.decimal "xidusn", null: false
    t.decimal "xidslt", null: false
    t.decimal "xidsqn", null: false
    t.decimal "session_num", null: false
    t.decimal "serial_num", null: false
    t.decimal "flag"
    t.decimal "start_scn"
    t.decimal "effective_scn", null: false
    t.decimal "offset"
    t.binary "tx_data"
  end

  create_table "logmnr_seed$", primary_key: ["logmnr_uid", "obj#", "intcol#"], force: :cascade do |t|
    t.integer "seed_version", limit: 22, precision: 22
    t.integer "gather_version", limit: 22, precision: 22
    t.string "schemaname", limit: 30
    t.decimal "obj#"
    t.integer "objv#", limit: 22, precision: 22
    t.string "table_name", limit: 30
    t.string "col_name", limit: 30
    t.decimal "col#"
    t.decimal "intcol#"
    t.decimal "segcol#"
    t.decimal "type#"
    t.decimal "length"
    t.decimal "precision#"
    t.decimal "scale"
    t.decimal "null$", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#"], name: "logmnr_i1seed$"
    t.index ["logmnr_uid", "schemaname", "table_name", "col_name", "obj#", "intcol#"], name: "logmnr_i2seed$"
  end

  create_table "logmnr_session$", primary_key: "session#", id: :decimal, force: :cascade do |t|
    t.decimal "client#"
    t.string "session_name", limit: 128, null: false
    t.decimal "db_id"
    t.decimal "resetlogs_change#"
    t.decimal "session_attr"
    t.string "session_attr_verbose", limit: 400
    t.decimal "start_scn"
    t.decimal "end_scn"
    t.decimal "spill_scn"
    t.date "spill_time"
    t.decimal "oldest_scn"
    t.decimal "resume_scn"
    t.string "global_db_name", limit: 128
    t.decimal "reset_timestamp"
    t.decimal "branch_scn"
    t.string "version", limit: 64
    t.string "redo_compat", limit: 20
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.decimal "spare4"
    t.decimal "spare5"
    t.date "spare6"
    t.string "spare7", limit: 1000
    t.string "spare8", limit: 1000
    t.index ["session_name"], name: "logmnr_session_uk1", unique: true
  end

  create_table "logmnr_session_actions$", primary_key: ["logmnrsession#", "actionname"], force: :cascade do |t|
    t.decimal "flagsruntime", default: "0.0"
    t.decimal "dropscn"
    t.datetime "modifytime"
    t.datetime "dispatchtime"
    t.datetime "droptime"
    t.decimal "lcrcount", default: "0.0"
    t.string "actionname", limit: 30, null: false
    t.decimal "logmnrsession#", null: false
    t.decimal "processrole#", null: false
    t.decimal "actiontype#", null: false
    t.decimal "flagsdefinetime"
    t.datetime "createtime"
    t.decimal "xidusn"
    t.decimal "xidslt"
    t.decimal "xidsqn"
    t.decimal "thread#"
    t.decimal "startscn"
    t.decimal "startsubscn"
    t.decimal "endscn"
    t.decimal "endsubscn"
    t.decimal "rbasqn"
    t.decimal "rbablk"
    t.decimal "rbabyte"
    t.decimal "session#"
    t.decimal "obj#"
    t.decimal "attr1"
    t.decimal "attr2"
    t.decimal "attr3"
    t.decimal "spare1"
    t.decimal "spare2"
    t.datetime "spare3"
    t.string "spare4", limit: 2000
  end

  create_table "logmnr_session_evolve$", primary_key: ["session#", "db_id", "reset_scn", "reset_timestamp"], force: :cascade do |t|
    t.decimal "branch_level"
    t.decimal "session#", null: false
    t.decimal "db_id", null: false
    t.decimal "reset_scn", null: false
    t.decimal "reset_timestamp", null: false
    t.decimal "prev_reset_scn"
    t.decimal "prev_reset_timestamp"
    t.decimal "status"
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.date "spare4"
  end

  create_table "logmnr_spill$", primary_key: ["session#", "xidusn", "xidslt", "xidsqn", "chunk", "startidx", "endidx", "flag", "sequence#"], force: :cascade do |t|
    t.decimal "session#", null: false
    t.decimal "xidusn", null: false
    t.decimal "xidslt", null: false
    t.decimal "xidsqn", null: false
    t.decimal "chunk", null: false
    t.decimal "startidx", null: false
    t.decimal "endidx", null: false
    t.decimal "flag", null: false
    t.decimal "sequence#", null: false
    t.binary "spill_data"
    t.decimal "spare1"
    t.decimal "spare2"
  end

  create_table "logmnr_subcoltype$", primary_key: ["logmnr_uid", "obj#", "intcol#", "toid"], force: :cascade do |t|
    t.decimal "intcol#", null: false
    t.raw "toid", limit: 16, null: false
    t.decimal "version#", null: false
    t.decimal "intcols"
    t.raw "intcol#s"
    t.decimal "flags"
    t.decimal "synobj#"
    t.decimal "obj#", null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "intcol#", "toid"], name: "logmnr_i1subcoltype$"
  end

  create_table "logmnr_tab$", primary_key: ["logmnr_uid", "obj#"], force: :cascade do |t|
    t.integer "ts#", limit: 22, precision: 22
    t.integer "cols", limit: 22, precision: 22
    t.integer "property", limit: 22, precision: 22
    t.integer "intcols", limit: 22, precision: 22
    t.integer "kernelcols", limit: 22, precision: 22
    t.integer "bobj#", limit: 22, precision: 22
    t.integer "trigflag", limit: 22, precision: 22
    t.integer "flags", limit: 22, precision: 22
    t.integer "obj#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "bobj#"], name: "logmnr_i2tab$"
    t.index ["logmnr_uid", "obj#"], name: "logmnr_i1tab$"
  end

  create_table "logmnr_tabcompart$", primary_key: ["logmnr_uid", "obj#"], force: :cascade do |t|
    t.integer "obj#", limit: 22, precision: 22
    t.integer "bo#", limit: 22, precision: 22
    t.integer "part#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "bo#"], name: "logmnr_i2tabcompart$"
    t.index ["logmnr_uid", "obj#"], name: "logmnr_i1tabcompart$"
  end

  create_table "logmnr_tabpart$", primary_key: ["logmnr_uid", "obj#", "bo#"], force: :cascade do |t|
    t.integer "obj#", limit: 22, precision: 22
    t.integer "ts#", limit: 22, precision: 22
    t.decimal "part#"
    t.integer "bo#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "bo#"], name: "logmnr_i2tabpart$"
    t.index ["logmnr_uid", "obj#", "bo#"], name: "logmnr_i1tabpart$"
  end

  create_table "logmnr_tabsubpart$", primary_key: ["logmnr_uid", "obj#", "pobj#"], force: :cascade do |t|
    t.integer "obj#", limit: 22, precision: 22
    t.integer "dataobj#", limit: 22, precision: 22
    t.integer "pobj#", limit: 22, precision: 22
    t.integer "subpart#", limit: 22, precision: 22
    t.integer "ts#", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "obj#", "pobj#"], name: "logmnr_i1tabsubpart$"
    t.index ["logmnr_uid", "pobj#"], name: "logmnr_i2tabsubpart$"
  end

  create_table "logmnr_ts$", primary_key: ["logmnr_uid", "ts#"], force: :cascade do |t|
    t.integer "ts#", limit: 22, precision: 22
    t.string "name", limit: 30
    t.integer "owner#", limit: 22, precision: 22
    t.integer "blocksize", limit: 22, precision: 22, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "ts#"], name: "logmnr_i1ts$"
  end

  create_table "logmnr_type$", primary_key: ["logmnr_uid", "toid", "version#"], force: :cascade do |t|
    t.decimal "version#"
    t.string "version", limit: 30
    t.raw "tvoid", limit: 16
    t.decimal "typecode"
    t.decimal "properties"
    t.decimal "attributes"
    t.decimal "methods"
    t.decimal "hiddenmethods"
    t.decimal "supertypes"
    t.decimal "subtypes"
    t.decimal "externtype"
    t.string "externname", limit: 4000
    t.string "helperclassname", limit: 4000
    t.decimal "local_attrs"
    t.decimal "local_methods"
    t.raw "typeid", limit: 16
    t.raw "roottoid", limit: 16
    t.decimal "spare1"
    t.decimal "spare2"
    t.decimal "spare3"
    t.raw "supertoid", limit: 16
    t.raw "hashcode", limit: 17
    t.raw "toid", limit: 16, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "toid", "version#"], name: "logmnr_i1type$"
  end

  create_table "logmnr_uid$", primary_key: "session#", id: :decimal, force: :cascade do |t|
    t.integer "logmnr_uid", limit: 22, precision: 22
  end

  create_table "logmnr_user$", primary_key: ["logmnr_uid", "user#"], force: :cascade do |t|
    t.integer "user#", limit: 22, precision: 22
    t.string "name", limit: 30, null: false
    t.integer "logmnr_uid", limit: 22, precision: 22
    t.integer "logmnr_flags", limit: 22, precision: 22
    t.index ["logmnr_uid", "user#"], name: "logmnr_i1user$"
  end

  create_table "logmnrc_dbname_uid_map", primary_key: "global_name", id: { type: :string, limit: 128 }, force: :cascade do |t|
    t.decimal "logmnr_uid"
    t.decimal "flags"
  end

  create_table "logmnrc_gsba", primary_key: ["logmnr_uid", "as_of_scn"], force: :cascade do |t|
    t.decimal "logmnr_uid", null: false
    t.decimal "as_of_scn", null: false
    t.decimal "fdo_length"
    t.raw "fdo_value", limit: 255
    t.decimal "charsetid"
    t.decimal "ncharsetid"
    t.decimal "dbtimezone_len"
    t.string "dbtimezone_value", limit: 64
    t.decimal "logmnr_spare1"
    t.decimal "logmnr_spare2"
    t.string "logmnr_spare3", limit: 1000
    t.date "logmnr_spare4"
  end

  create_table "logmnrc_gsii", primary_key: ["logmnr_uid", "obj#"], force: :cascade do |t|
    t.decimal "logmnr_uid", null: false
    t.decimal "obj#", null: false
    t.decimal "bo#", null: false
    t.decimal "indtype#", null: false
    t.decimal "drop_scn"
    t.decimal "logmnr_spare1"
    t.decimal "logmnr_spare2"
    t.string "logmnr_spare3", limit: 1000
    t.date "logmnr_spare4"
  end

  create_table "logmnrc_gtcs", primary_key: ["logmnr_uid", "obj#", "objv#", "intcol#"], force: :cascade do |t|
    t.decimal "logmnr_uid", null: false
    t.decimal "obj#", null: false
    t.decimal "objv#", null: false
    t.decimal "segcol#", null: false
    t.decimal "intcol#", null: false
    t.string "colname", limit: 30, null: false
    t.decimal "type#", null: false
    t.decimal "length"
    t.decimal "precision"
    t.decimal "scale"
    t.decimal "interval_leading_precision"
    t.decimal "interval_trailing_precision"
    t.decimal "property"
    t.raw "toid", limit: 16
    t.decimal "charsetid"
    t.decimal "charsetform"
    t.string "typename", limit: 30
    t.string "fqcolname", limit: 4000
    t.decimal "numintcols"
    t.decimal "numattrs"
    t.decimal "adtorder"
    t.decimal "logmnr_spare1"
    t.decimal "logmnr_spare2"
    t.string "logmnr_spare3", limit: 1000
    t.date "logmnr_spare4"
    t.decimal "logmnr_spare5"
    t.decimal "logmnr_spare6"
    t.decimal "logmnr_spare7"
    t.decimal "logmnr_spare8"
    t.decimal "logmnr_spare9"
    t.decimal "col#"
    t.string "xtypeschemaname", limit: 30
    t.string "xtypename", limit: 4000
    t.string "xfqcolname", limit: 4000
    t.decimal "xtopintcol"
    t.decimal "xreffedtableobjn"
    t.decimal "xreffedtableobjv"
    t.decimal "xcoltypeflags"
    t.decimal "xopqtypetype"
    t.decimal "xopqtypeflags"
    t.decimal "xopqlobintcol"
    t.decimal "xopqobjintcol"
    t.decimal "xxmlintcol"
    t.decimal "eaowner#"
    t.string "eamkeyid", limit: 64
    t.decimal "eaencalg"
    t.decimal "eaintalg"
    t.raw "eacolklc"
    t.decimal "eaklclen"
    t.decimal "eaflags"
    t.index ["logmnr_uid", "obj#", "objv#", "segcol#", "intcol#"], name: "logmnrc_i2gtcs"
  end

  create_table "logmnrc_gtlo", primary_key: ["logmnr_uid", "keyobj#", "baseobjv#"], force: :cascade do |t|
    t.decimal "logmnr_uid", null: false
    t.decimal "keyobj#", null: false
    t.decimal "lvlcnt", null: false
    t.decimal "baseobj#", null: false
    t.decimal "baseobjv#", null: false
    t.decimal "lvl1obj#"
    t.decimal "lvl2obj#"
    t.decimal "lvl0type#", null: false
    t.decimal "lvl1type#"
    t.decimal "lvl2type#"
    t.decimal "owner#"
    t.string "ownername", limit: 30, null: false
    t.string "lvl0name", limit: 30, null: false
    t.string "lvl1name", limit: 30
    t.string "lvl2name", limit: 30
    t.decimal "intcols", null: false
    t.decimal "cols"
    t.decimal "kernelcols"
    t.decimal "tab_flags"
    t.decimal "trigflag"
    t.decimal "assoc#"
    t.decimal "obj_flags"
    t.decimal "ts#"
    t.string "tsname", limit: 30
    t.decimal "property"
    t.decimal "start_scn", null: false
    t.decimal "drop_scn"
    t.decimal "xidusn"
    t.decimal "xidslt"
    t.decimal "xidsqn"
    t.decimal "flags"
    t.decimal "logmnr_spare1"
    t.decimal "logmnr_spare2"
    t.string "logmnr_spare3", limit: 1000
    t.date "logmnr_spare4"
    t.decimal "logmnr_spare5"
    t.decimal "logmnr_spare6"
    t.decimal "logmnr_spare7"
    t.decimal "logmnr_spare8"
    t.decimal "logmnr_spare9"
    t.decimal "parttype"
    t.decimal "subparttype"
    t.decimal "unsupportedcols"
    t.decimal "complextypecols"
    t.decimal "ntparentobjnum"
    t.decimal "ntparentobjversion"
    t.decimal "ntparentintcolnum"
    t.decimal "logmnrtloflags"
    t.string "logmnrmcv", limit: 30
    t.index ["logmnr_uid", "baseobj#", "baseobjv#"], name: "logmnrc_i2gtlo"
    t.index ["logmnr_uid", "drop_scn"], name: "logmnrc_i3gtlo"
  end

  create_table "logmnrp_ctas_part_map", primary_key: ["logmnr_uid", "baseobjv#", "keyobj#"], force: :cascade do |t|
    t.decimal "logmnr_uid", null: false
    t.decimal "baseobj#", null: false
    t.decimal "baseobjv#", null: false
    t.decimal "keyobj#", null: false
    t.decimal "part#", null: false
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 1000
    t.index ["logmnr_uid", "baseobj#", "baseobjv#", "part#"], name: "logmnrp_ctas_part_map_i"
  end

# Could not dump table "logmnrt_mddl$" because of following StandardError
#   Unknown type 'ROWID' for column 'source_rowid'

  create_table "logstdby$apply_milestone", id: false, force: :cascade do |t|
    t.decimal "session_id", null: false
    t.decimal "commit_scn", null: false
    t.date "commit_time"
    t.decimal "synch_scn", null: false
    t.decimal "epoch", null: false
    t.decimal "processed_scn", null: false
    t.date "processed_time"
    t.decimal "fetchlwm_scn", default: "0.0", null: false
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
  end

  create_table "logstdby$apply_progress", id: false, force: :cascade do |t|
    t.decimal "xidusn"
    t.decimal "xidslt"
    t.decimal "xidsqn"
    t.decimal "commit_scn"
    t.date "commit_time"
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
  end

  create_table "logstdby$eds_tables", primary_key: ["owner", "table_name"], force: :cascade do |t|
    t.string "owner", limit: 30, null: false
    t.string "table_name", limit: 30, null: false
    t.string "shadow_table_name", limit: 30
    t.string "base_trigger_name", limit: 30
    t.string "shadow_trigger_name", limit: 30
    t.string "dblink"
    t.decimal "flags"
    t.string "state"
    t.decimal "objv"
    t.decimal "obj#"
    t.decimal "sobj#"
    t.datetime "ctime"
    t.decimal "spare1"
    t.string "spare2"
    t.decimal "spare3"
  end

  create_table "logstdby$events", id: false, force: :cascade do |t|
    t.datetime "event_time", null: false
    t.decimal "current_scn"
    t.decimal "commit_scn"
    t.decimal "xidusn"
    t.decimal "xidslt"
    t.decimal "xidsqn"
    t.decimal "errval"
    t.string "event", limit: 2000
    t.text "full_event"
    t.string "error", limit: 2000
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
    t.index ["commit_scn"], name: "logstdby$events_ind_scn", tablespace: "sysaux"
    t.index ["event_time"], name: "logstdby$events_ind", tablespace: "sysaux"
    t.index ["xidusn", "xidslt", "xidsqn"], name: "logstdby$events_ind_xid", tablespace: "sysaux"
  end

  create_table "logstdby$flashback_scn", primary_key: "primary_scn", id: :decimal, force: :cascade do |t|
    t.date "primary_time"
    t.decimal "standby_scn"
    t.date "standby_time"
    t.decimal "spare1"
    t.decimal "spare2"
    t.date "spare3"
  end

  create_table "logstdby$history", id: false, force: :cascade do |t|
    t.decimal "stream_sequence#"
    t.decimal "lmnr_sid"
    t.decimal "dbid"
    t.decimal "first_change#"
    t.decimal "last_change#"
    t.decimal "source"
    t.decimal "status"
    t.date "first_time"
    t.date "last_time"
    t.string "dgname"
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
  end

  create_table "logstdby$parameters", id: false, force: :cascade do |t|
    t.string "name", limit: 30
    t.string "value", limit: 2000
    t.decimal "type"
    t.decimal "scn"
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
  end

  create_table "logstdby$plsql", id: false, force: :cascade do |t|
    t.decimal "session_id"
    t.decimal "start_finish"
    t.text "call_text"
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
  end

  create_table "logstdby$scn", id: false, force: :cascade do |t|
    t.decimal "obj#"
    t.string "objname", limit: 4000
    t.string "schema", limit: 30
    t.string "type", limit: 20
    t.decimal "scn"
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
  end

  create_table "logstdby$skip", id: false, force: :cascade do |t|
    t.decimal "error"
    t.string "statement_opt", limit: 30
    t.string "schema", limit: 30
    t.string "name", limit: 65
    t.decimal "use_like"
    t.string "esc", limit: 1
    t.string "proc", limit: 98
    t.decimal "active"
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
    t.index ["statement_opt"], name: "logstdby$skip_idx2", tablespace: "sysaux"
    t.index ["use_like", "schema", "name"], name: "logstdby$skip_idx1", tablespace: "sysaux"
  end

  create_table "logstdby$skip_support", id: false, force: :cascade do |t|
    t.decimal "action", null: false
    t.string "name", limit: 30, null: false
    t.integer "reg", precision: 38
    t.decimal "spare1"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
    t.index ["name", "action"], name: "logstdby$skip_ind", unique: true, tablespace: "sysaux"
  end

  create_table "logstdby$skip_transaction", id: false, force: :cascade do |t|
    t.decimal "xidusn"
    t.decimal "xidslt"
    t.decimal "xidsqn"
    t.decimal "active"
    t.decimal "commit_scn"
    t.decimal "spare2"
    t.string "spare3", limit: 2000
  end

  create_table "mview$_adv_ajg", primary_key: "ajgid#", id: :decimal, comment: "Anchor-join graph representation", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "ajgdeslen", null: false
    t.raw "ajgdes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency"
  end

  create_table "mview$_adv_basetable", id: false, comment: "Base tables refered by a query", force: :cascade do |t|
    t.decimal "collectionid#", null: false
    t.decimal "queryid#", null: false
    t.string "owner", limit: 30
    t.string "table_name", limit: 30
    t.decimal "table_type"
    t.index ["queryid#"], name: "mview$_adv_basetable_idx_01"
  end

  create_table "mview$_adv_clique", primary_key: "cliqueid#", id: :decimal, comment: "Table for storing canonical form of Clique queries", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "cliquedeslen", null: false
    t.raw "cliquedes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency", null: false
    t.decimal "bytecost", null: false
    t.decimal "rowsize", null: false
    t.decimal "numrows", null: false
  end

  create_table "mview$_adv_eligible", primary_key: ["sumobjn#", "runid#"], comment: "Summary management rewrite eligibility information", force: :cascade do |t|
    t.decimal "sumobjn#", null: false
    t.decimal "runid#", null: false
    t.decimal "bytecost", null: false
    t.decimal "flags", null: false
    t.decimal "frequency", null: false
  end

# Could not dump table "mview$_adv_exceptions" because of following StandardError
#   Unknown type 'ROWID' for column 'bad_rowid'

  create_table "mview$_adv_filter", primary_key: ["filterid#", "subfilternum#"], comment: "Table for workload filter definition", force: :cascade do |t|
    t.decimal "filterid#", null: false
    t.decimal "subfilternum#", null: false
    t.decimal "subfiltertype", null: false
    t.string "str_value", limit: 1028
    t.decimal "num_value1"
    t.decimal "num_value2"
    t.date "date_value1"
    t.date "date_value2"
  end

  create_table "mview$_adv_filterinstance", id: false, comment: "Table for workload filter instance definition", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "filterid#"
    t.decimal "subfilternum#"
    t.decimal "subfiltertype"
    t.string "str_value", limit: 1028
    t.decimal "num_value1"
    t.decimal "num_value2"
    t.date "date_value1"
    t.date "date_value2"
  end

  create_table "mview$_adv_fjg", primary_key: "fjgid#", id: :decimal, comment: "Representation for query join sub-graph not in AJG ", force: :cascade do |t|
    t.decimal "ajgid#", null: false
    t.decimal "fjgdeslen", null: false
    t.raw "fjgdes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency"
  end

  create_table "mview$_adv_gc", primary_key: "gcid#", id: :decimal, comment: "Group-by columns of a query", force: :cascade do |t|
    t.decimal "fjgid#", null: false
    t.decimal "gcdeslen", null: false
    t.raw "gcdes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency"
  end

  create_table "mview$_adv_info", primary_key: ["runid#", "seq#"], comment: "Internal table for passing information from the SQL analyzer", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "seq#", null: false
    t.decimal "type", null: false
    t.decimal "infolen", null: false
    t.raw "info"
    t.decimal "status"
    t.decimal "flag"
  end

# Could not dump table "mview$_adv_journal" because of following StandardError
#   Unknown type 'LONG' for column 'text'

  create_table "mview$_adv_level", primary_key: ["runid#", "levelid#"], comment: "Level definition", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "levelid#", null: false
    t.decimal "dimobj#"
    t.decimal "flags", null: false
    t.decimal "tblobj#", null: false
    t.raw "columnlist", limit: 70, null: false
    t.string "levelname", limit: 30
  end

  create_table "mview$_adv_log", primary_key: "runid#", id: :decimal, comment: "Log all calls to summary advisory functions", force: :cascade do |t|
    t.decimal "filterid#"
    t.date "run_begin"
    t.date "run_end"
    t.decimal "run_type"
    t.string "uname", limit: 30
    t.decimal "status", null: false
    t.string "message", limit: 2000
    t.decimal "completed"
    t.decimal "total"
    t.string "error_code", limit: 20
  end

# Could not dump table "mview$_adv_output" because of following StandardError
#   Unknown type 'LONG' for column 'query_text'

  create_table "mview$_adv_parameters", primary_key: "parameter_name", id: { type: :string, limit: 30 }, comment: "Summary advisor tuning parameters", force: :cascade do |t|
    t.decimal "parameter_type", null: false
    t.string "string_value", limit: 30
    t.date "date_value"
    t.decimal "numerical_value"
  end

# Could not dump table "mview$_adv_plan" because of following StandardError
#   Unknown type 'LONG' for column 'other'

# Could not dump table "mview$_adv_pretty" because of following StandardError
#   Unknown type 'LONG' for column 'sql_text'

  create_table "mview$_adv_rollup", primary_key: ["runid#", "clevelid#", "plevelid#"], comment: "Each row repesents either a functional dependency or join-key relationship", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "clevelid#", null: false
    t.decimal "plevelid#", null: false
    t.decimal "flags", null: false
  end

  create_table "mview$_adv_sqldepend", id: false, comment: "Temporary table for workload collections", force: :cascade do |t|
    t.decimal "collectionid#"
    t.decimal "inst_id"
    t.raw "from_address", limit: 16
    t.decimal "from_hash"
    t.string "to_owner", limit: 64
    t.string "to_name", limit: 1000
    t.decimal "to_type"
    t.decimal "cardinality"
    t.index ["collectionid#", "from_address", "from_hash", "inst_id"], name: "mview$_adv_sqldepend_idx_01"
  end

# Could not dump table "mview$_adv_temp" because of following StandardError
#   Unknown type 'LONG' for column 'text'

# Could not dump table "mview$_adv_workload" because of following StandardError
#   Unknown type 'LONG' for column 'sql_text'

# Could not dump table "ol$" because of following StandardError
#   Unknown type 'LONG' for column 'sql_text'

  create_table "ol$hints", temporary: true, id: false, force: :cascade do |t|
    t.string "ol_name", limit: 30
    t.decimal "hint#"
    t.string "category", limit: 30
    t.decimal "hint_type"
    t.string "hint_text", limit: 512
    t.decimal "stage#"
    t.decimal "node#"
    t.string "table_name", limit: 30
    t.decimal "table_tin"
    t.decimal "table_pos"
    t.decimal "ref_id"
    t.string "user_table_name", limit: 64
    t.float "cost", limit: 126
    t.float "cardinality", limit: 126
    t.float "bytes", limit: 126
    t.decimal "hint_textoff"
    t.decimal "hint_textlen"
    t.string "join_pred", limit: 2000
    t.decimal "spare1"
    t.decimal "spare2"
    t.text "hint_string"
    t.index ["ol_name", "hint#"], name: "ol$hnt_num", unique: true
  end

  create_table "ol$nodes", temporary: true, id: false, force: :cascade do |t|
    t.string "ol_name", limit: 30
    t.string "category", limit: 30
    t.decimal "node_id"
    t.decimal "parent_id"
    t.decimal "node_type"
    t.decimal "node_textlen"
    t.decimal "node_textoff"
    t.string "node_name", limit: 64
  end

  create_table "repcat$_audit_attribute", primary_key: "attribute", id: { type: :string, limit: 30, comment: "Description of the attribute" }, comment: "Information about attributes automatically maintained for replication", force: :cascade do |t|
    t.integer "data_type_id", precision: 38, null: false, comment: "Datatype of the attribute value"
    t.integer "data_length", precision: 38, comment: "Length of the attribute value in byte"
    t.string "source", limit: 92, null: false, comment: "Name of the function which returns the attribute value"
  end

  create_table "repcat$_audit_column", primary_key: ["column_name", "oname", "sname"], comment: "Information about columns in all shadow tables for all replicated tables in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of the shadow table"
    t.string "oname", limit: 30, null: false, comment: "Name of the shadow table"
    t.string "column_name", limit: 30, null: false, comment: "Name of the column in the shadow table"
    t.string "base_sname", limit: 30, null: false, comment: "Owner of replicated table"
    t.string "base_oname", limit: 30, null: false, comment: "Name of the replicated table"
    t.integer "base_conflict_type_id", precision: 38, null: false, comment: "Type of conflict"
    t.string "base_reference_name", limit: 30, null: false, comment: "Table name, unique constraint name, or column group name"
    t.string "attribute", limit: 30, null: false, comment: "Description of the attribute"
    t.index ["attribute"], name: "repcat$_audit_column_f1_idx"
    t.index ["base_sname", "base_oname", "base_conflict_type_id", "base_reference_name"], name: "repcat$_audit_column_f2_idx"
  end

  create_table "repcat$_column_group", primary_key: ["sname", "oname", "group_name"], comment: "All column groups of replicated tables in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of replicated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the replicated object"
    t.string "group_name", limit: 30, null: false, comment: "Name of the column group"
    t.string "group_comment", limit: 80, comment: "Description of the column group"
  end

  create_table "repcat$_conflict", primary_key: ["sname", "oname", "conflict_type_id", "reference_name"], comment: "All conflicts for which users have specified resolutions in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of replicated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the replicated object"
    t.integer "conflict_type_id", precision: 38, null: false, comment: "Type of conflict"
    t.string "reference_name", limit: 30, null: false, comment: "Table name, unique constraint name, or column group name"
  end

  create_table "repcat$_ddl", id: false, comment: "Arguments that do not fit in a single repcat log record", force: :cascade do |t|
    t.decimal "log_id", comment: "Identifying number of the repcat log record"
    t.string "source", limit: 128, comment: "Name of the database at which the request originated"
    t.string "role", limit: 1, comment: "Is this database the masterdef for the request"
    t.string "master", limit: 128, comment: "Name of the database that processes this request"
    t.integer "line", precision: 38, comment: "Ordering of records within a single request"
    t.string "text", limit: 2000, comment: "Portion of an argument"
    t.integer "ddl_num", precision: 38, default: 1, comment: "Ordering of DDLs to execute"
    t.index ["log_id", "source", "role", "master", "line"], name: "repcat$_ddl", unique: true
    t.index ["log_id", "source", "role", "master"], name: "repcat$_ddl_index"
  end

  create_table "repcat$_exceptions", primary_key: "exception_id", id: { type: :decimal, comment: "Internal primary key of the exceptions table." }, comment: "Repcat processing exceptions table.", force: :cascade do |t|
    t.string "user_name", limit: 30, comment: "User name of user submitting the exception."
    t.text "request", comment: "Originating request containing the exception."
    t.decimal "job", comment: "Originating job containing the exception."
    t.date "error_date", comment: "Date of occurance for the exception."
    t.decimal "error_number", comment: "Error number generating the exception."
    t.string "error_message", limit: 4000, comment: "Error message associated with the error generating the exception."
    t.decimal "line_number", comment: "Line number of the exception."
  end

  create_table "repcat$_extension", primary_key: "extension_id", id: { type: :raw, limit: 16, comment: "Globally unique identifier for replication extension" }, comment: "Information about replication extension requests", force: :cascade do |t|
    t.decimal "extension_code", comment: "Kind of replication extension"
    t.string "masterdef", limit: 128, comment: "Master definition site for replication extension"
    t.string "export_required", limit: 1, comment: "YES if this extension requires an export, and NO if no export is required"
    t.decimal "repcatlog_id", comment: "Identifier of repcatlog records related to replication extension"
    t.decimal "extension_status", comment: "Status of replication extension"
    t.decimal "flashback_scn", comment: "Flashback_scn for export or change-based recovery for replication extension"
    t.string "push_to_mdef", limit: 1, comment: "YES if existing masters partially push to masterdef, NO if no pushing"
    t.string "push_to_new", limit: 1, comment: "YES if existing masters partially push to new masters, NO if no pushing"
    t.decimal "percentage_for_catchup_mdef", comment: "Fraction of push to masterdef cycle devoted to catching up"
    t.decimal "cycle_seconds_mdef", comment: "Length of push to masterdef cycle when catching up"
    t.decimal "percentage_for_catchup_new", comment: "Fraction of push to new masters cycle devoted to catching up"
    t.decimal "cycle_seconds_new", comment: "Length of push to new masters cycle when catching up"
  end

  create_table "repcat$_flavor_objects", primary_key: ["sname", "oname", "type", "gname", "flavor_id", "gowner"], comment: "Replicated objects in flavors", force: :cascade do |t|
    t.decimal "flavor_id", null: false, comment: "Flavor identifier"
    t.string "gowner", limit: 30, default: "PUBLIC", null: false, comment: "Owner of the object group containing object"
    t.string "gname", limit: 30, null: false, comment: "Object group containing object"
    t.string "sname", limit: 30, null: false, comment: "Schema containing object"
    t.string "oname", limit: 30, null: false, comment: "Name of object"
    t.decimal "type", null: false, comment: "Object type"
    t.decimal "version#", comment: "Version# of a user-defined type"
    t.raw "hashcode", limit: 17, comment: "Hashcode of a user-defined type"
    t.raw "columns_present", limit: 125, comment: "For tables, encoded mapping of columns present"
    t.index ["flavor_id", "gname", "gowner"], name: "repcat$_flavor_objects_fg"
    t.index ["gname", "flavor_id", "gowner"], name: "repcat$_flavor_objects_fk2_idx"
    t.index ["gname", "gowner"], name: "repcat$_flavor_objects_fk1_idx"
  end

  create_table "repcat$_flavors", id: false, comment: "Flavors defined for replicated object groups", force: :cascade do |t|
    t.decimal "flavor_id", null: false, comment: "Flavor identifier, unique within object group"
    t.string "gowner", limit: 30, default: "PUBLIC", comment: "Owner of the object group"
    t.string "gname", limit: 30, null: false, comment: "Name of the object group"
    t.string "fname", limit: 30, comment: "Name of the flavor"
    t.date "creation_date", comment: "Date on which the flavor was created"
    t.decimal "created_by", default: "0.0", comment: "Identifier of user that created the flavor"
    t.string "published", limit: 1, default: "N", comment: "Indicates whether flavor is published (Y/N) or obsolete (O)"
    t.index ["fname"], name: "repcat$_flavors_fname"
    t.index ["gname", "flavor_id", "gowner"], name: "repcat$_flavors_unq1", unique: true
    t.index ["gname", "fname", "gowner"], name: "repcat$_flavors_gname", unique: true
    t.index ["gname", "gowner"], name: "repcat$_flavors_fk1_idx"
  end

  create_table "repcat$_generated", primary_key: ["sname", "oname", "type", "base_sname", "base_oname", "base_type"], comment: "Objects generated to support replication", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Schema containing the generated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the generated object"
    t.integer "type", precision: 38, null: false, comment: "Type of the generated object"
    t.decimal "reason", comment: "Reason the object was generated"
    t.string "base_sname", limit: 30, null: false, comment: "Name of the object's owner"
    t.string "base_oname", limit: 30, null: false, comment: "Name of the object"
    t.integer "base_type", precision: 38, null: false, comment: "Type of the object"
    t.string "package_prefix", limit: 30, comment: "Prefix for package wrapper"
    t.string "procedure_prefix", limit: 30, comment: "Procedure prefix for package wrapper or procedure wrapper"
    t.string "distributed", limit: 1, comment: "Is the generated object separately generated at each master"
    t.index ["base_sname", "base_oname", "base_type"], name: "repcat$_generated_n1"
    t.index ["sname", "oname", "type"], name: "repcat$_repgen_prnt_idx"
  end

  create_table "repcat$_grouped_column", primary_key: ["sname", "oname", "group_name", "column_name", "pos"], comment: "Columns in all column groups of replicated tables in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of replicated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the replicated object"
    t.string "group_name", limit: 30, null: false, comment: "Name of the column group"
    t.string "column_name", limit: 30, null: false, comment: "Name of the column in the column group"
    t.decimal "pos", null: false, comment: "Position of a column or an attribute in the table"
    t.index ["sname", "oname", "group_name"], name: "repcat$_grouped_column_f1_idx"
  end

  create_table "repcat$_instantiation_ddl", primary_key: ["refresh_template_id", "phase", "ddl_num"], comment: "Table containing supplementary DDL to be executed during instantiation.", force: :cascade do |t|
    t.decimal "refresh_template_id", null: false, comment: "Primary key of template containing supplementary DDL."
    t.text "ddl_text", comment: "Supplementary DDL string."
    t.decimal "ddl_num", null: false, comment: "Column for ordering of supplementary DDL."
    t.decimal "phase", null: false, comment: "Phase to execute the DDL string."
  end

  create_table "repcat$_key_columns", primary_key: ["sname", "oname", "col"], comment: "Primary columns for a table using column-level replication", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Schema containing table"
    t.string "oname", limit: 30, null: false, comment: "Name of the table"
    t.integer "type", precision: 38, comment: "Type identifier"
    t.string "col", limit: 30, null: false, comment: "Column in the table"
    t.index ["sname", "oname", "type"], name: "repcat$_key_columns_prnt_idx"
  end

  create_table "repcat$_object_parms", primary_key: ["template_parameter_id", "template_object_id"], force: :cascade do |t|
    t.decimal "template_parameter_id", null: false, comment: "Primary key of template parameter."
    t.decimal "template_object_id", null: false, comment: "Primary key of object using the paramter."
    t.index ["template_object_id"], name: "repcat$_object_parms_n2"
  end

  create_table "repcat$_object_types", primary_key: "object_type_id", id: { type: :decimal, comment: "Internal primary key of the template object types table." }, comment: "Internal table for template object types.", force: :cascade do |t|
    t.string "object_type_name", limit: 200, comment: "Descriptive name for the object type."
    t.raw "flags", limit: 255, comment: "Internal flags for object type processing."
    t.string "spare1", limit: 4000, comment: "Reserved for future use."
  end

  create_table "repcat$_parameter_column", primary_key: ["sname", "oname", "conflict_type_id", "reference_name", "sequence_no", "parameter_table_name", "parameter_sequence_no", "column_pos"], comment: "All columns used for resolving conflicts in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of replicated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the replicated object"
    t.integer "conflict_type_id", precision: 38, null: false, comment: "Type of conflict"
    t.string "reference_name", limit: 30, null: false, comment: "Table name, unique constraint name, or column group name"
    t.decimal "sequence_no", null: false, comment: "Ordering on resolution"
    t.string "parameter_table_name", limit: 30, null: false, comment: "Name of the table to which the parameter column belongs"
    t.string "parameter_column_name", limit: 4000, comment: "Name of the parameter column used for resolving the conflict"
    t.decimal "parameter_sequence_no", null: false, comment: "Ordering on parameter column"
    t.decimal "column_pos", null: false, comment: "Column position of an attribute or a column"
    t.decimal "attribute_sequence_no", comment: "Sequence number for an attribute of an ADT/pkREF column or a scalar column"
    t.index ["sname", "oname", "conflict_type_id", "reference_name", "sequence_no"], name: "repcat$_parameter_column_f1_i"
  end

  create_table "repcat$_priority", primary_key: ["sname", "priority_group", "priority"], comment: "Values and their corresponding priorities in all priority groups in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Name of the replicated object group"
    t.string "priority_group", limit: 30, null: false, comment: "Name of the priority group"
    t.decimal "priority", null: false, comment: "Priority of the value"
    t.raw "raw_value", comment: "Raw value"
    t.string "char_value", comment: "Blank-padded character string"
    t.decimal "number_value", comment: "Numeric value"
    t.date "date_value", comment: "Date value"
    t.string "varchar2_value", limit: 4000, comment: "Character string"
    t.string "nchar_value", comment: "NCHAR string"
    t.string "nvarchar2_value", comment: "NVARCHAR2 string"
    t.string "large_char_value", limit: 2000, comment: "Blank-padded character string over 255 characters"
    t.index ["priority_group", "sname"], name: "repcat$_priority_f1_idx"
  end

  create_table "repcat$_priority_group", primary_key: ["priority_group", "sname"], comment: "Information about all priority groups in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Name of the replicated object group"
    t.string "priority_group", limit: 30, null: false, comment: "Name of the priority group"
    t.integer "data_type_id", precision: 38, null: false, comment: "Datatype of the value in the priority group"
    t.integer "fixed_data_length", precision: 38, comment: "Length of the value in bytes if the datatype is CHAR"
    t.string "priority_comment", limit: 80, comment: "Description of the priority group"
    t.index ["sname", "priority_group", "data_type_id", "fixed_data_length"], name: "repcat$_priority_group_u1", unique: true
  end

  create_table "repcat$_refresh_templates", primary_key: "refresh_template_id", id: { type: :decimal, comment: "Internal primary key of the REPCAT$_REFRESH_TEMPLATES table." }, comment: "Primary table containing deployment template information.", force: :cascade do |t|
    t.string "owner", limit: 30, null: false, comment: "Owner of the refresh group template."
    t.string "refresh_group_name", limit: 30, null: false, comment: "Name of the refresh group to create during instantiation."
    t.string "refresh_template_name", limit: 30, null: false, comment: "Name of the refresh group template."
    t.string "template_comment", limit: 2000, comment: "Optional comment field for the refresh group template."
    t.string "public_template", limit: 1, comment: "Flag specifying public template or private template."
    t.date "last_modified", comment: "Date the row was last modified."
    t.decimal "modified_by", comment: "User id of the user that modified the row."
    t.date "creation_date", comment: "Date the row was created."
    t.decimal "created_by", comment: "User id of the user that created the row."
    t.decimal "refresh_group_id", default: "0.0", null: false, comment: "Internal primary key to default refresh group for the template."
    t.decimal "template_type_id", default: "1.0", null: false, comment: "Internal primary key to the template types."
    t.decimal "template_status_id", default: "0.0", null: false, comment: "Internal primary key to the template status table."
    t.raw "flags", limit: 255, comment: "Internal flags for the template."
    t.string "spare1", limit: 4000, comment: "Reserved for future use."
    t.index ["refresh_template_name"], name: "repcat$_refresh_templates_u1", unique: true
  end

  create_table "repcat$_repcat", primary_key: ["sname", "gowner"], comment: "Information about all replicated object groups", force: :cascade do |t|
    t.string "gowner", limit: 30, default: "PUBLIC", null: false, comment: "Owner of the object group"
    t.string "sname", limit: 30, null: false, comment: "Name of the replicated object group"
    t.string "master", limit: 1, comment: "Is the site a master site for the replicated object group"
    t.integer "status", precision: 38, comment: "If the site is a master, the master's status"
    t.string "schema_comment", limit: 80, comment: "Description of the replicated object group"
    t.decimal "flavor_id", comment: "Flavor identifier"
    t.raw "flag", limit: 4, default: "00000000", comment: "Miscellaneous repgroup info"
  end

  create_table "repcat$_repcatlog", primary_key: ["id", "source", "role", "master"], comment: "Information about asynchronous administration requests", force: :cascade do |t|
    t.decimal "version", comment: "Version of the repcat log record"
    t.decimal "id", null: false, comment: "Identifying number of repcat log record"
    t.string "source", limit: 128, null: false, comment: "Name of the database at which the request originated"
    t.string "userid", limit: 30, comment: "Name of the user who submitted the request"
    t.date "timestamp", comment: "When the request was submitted"
    t.string "role", limit: 1, null: false, comment: "Is this database the masterdef for the request"
    t.string "master", limit: 128, null: false, comment: "Name of the database that processes this request$_ddl"
    t.string "sname", limit: 30, comment: "Schema of replicated object"
    t.integer "request", precision: 38, comment: "Name of the requested operation"
    t.string "oname", limit: 30, comment: "Replicated object name, if applicable"
    t.integer "type", precision: 38, comment: "Type of replicated object, if applicable"
    t.string "a_comment", limit: 2000, comment: "Textual argument used for comments"
    t.string "bool_arg", limit: 1, comment: "Boolean argument"
    t.string "ano_bool_arg", limit: 1, comment: "Another Boolean argument"
    t.integer "int_arg", precision: 38, comment: "Integer argument"
    t.integer "ano_int_arg", precision: 38, comment: "Another integer argument"
    t.integer "lines", precision: 38, comment: "The number of rows in system.repcat$_ddl at the processing site"
    t.integer "status", precision: 38, comment: "Status of the request at this database"
    t.string "message", limit: 200, comment: "Error message associated with processing the request"
    t.decimal "errnum", comment: "Oracle error number associated with processing the request"
    t.string "gname", limit: 30, comment: "Name of the replicated object group"
    t.index ["gname", "sname", "oname", "type"], name: "repcat$_repcatlog_gname"
  end

  create_table "repcat$_repcolumn", primary_key: ["sname", "oname", "type", "cname"], comment: "Replicated columns for a table sorted alphabetically in ascending order", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Name of the object owner"
    t.string "oname", limit: 30, null: false, comment: "Name of the object"
    t.integer "type", precision: 38, null: false, comment: "Type of the object"
    t.string "cname", limit: 30, null: false, comment: "Column name"
    t.string "lcname", limit: 4000, comment: "Long column name"
    t.raw "toid", limit: 16, comment: "Type object identifier of a user-defined type"
    t.decimal "version#", comment: "Version# of a column of user-defined type"
    t.raw "hashcode", limit: 17, comment: "Hashcode of a column of user-defined type"
    t.string "ctype_name", limit: 30
    t.string "ctype_owner", limit: 30
    t.decimal "id", comment: "Column ID"
    t.decimal "pos", comment: "Ordering of column used as IN parameter in the replication procedures"
    t.string "top", limit: 30, comment: "Top column name for an attribute"
    t.raw "flag", limit: 2, default: "0000", comment: "Replication information about column"
    t.decimal "ctype", comment: "Type of the column"
    t.decimal "length", comment: "Length of the column in bytes"
    t.decimal "precision#", comment: "Length: decimal digits (NUMBER) or binary digits (FLOAT)"
    t.decimal "scale", comment: "Digits to right of decimal point in a number"
    t.decimal "null$", comment: "Does column allow NULL values?"
    t.decimal "charsetid", comment: "Character set identifier"
    t.decimal "charsetform", comment: "Character set form"
    t.raw "property", limit: 4, default: "00000000"
    t.decimal "clength", comment: "The maximum length of the column in characters"
    t.index ["sname", "oname", "type"], name: "repcat$_repcolumn_fk_idx"
  end

  create_table "repcat$_repgroup_privs", id: false, comment: "Information about users who are registered for object group privileges", force: :cascade do |t|
    t.decimal "userid", comment: "OBSOLETE COLUMN: Identifying number of the user"
    t.string "username", limit: 30, null: false, comment: "Identifying name of the registered user"
    t.string "gowner", limit: 30, comment: "Owner of the replicated object group"
    t.string "gname", limit: 30, comment: "Name of the replicated object group"
    t.decimal "global_flag", null: false, comment: "1 if gname is NULL, 0 otherwise"
    t.date "created", null: false, comment: "Registration date"
    t.decimal "privilege", comment: "Registered privileges"
    t.index ["global_flag", "username"], name: "repcat$_repgroup_privs_n1"
    t.index ["gname", "gowner"], name: "repcat$_repgroup_privs_fk_idx"
    t.index ["username", "gname", "gowner"], name: "repcat$_repgroup_privs_uk", unique: true
  end

  create_table "repcat$_repobject", primary_key: ["sname", "oname", "type"], comment: "Information about replicated objects", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Name of the object owner"
    t.string "oname", limit: 30, null: false, comment: "Name of the object"
    t.integer "type", precision: 38, null: false, comment: "Type of the object"
    t.decimal "version#", comment: "Version of objects of TYPE"
    t.raw "hashcode", limit: 17, comment: "Hashcode of objects of TYPE"
    t.decimal "id", comment: "Identifier of the local object"
    t.string "object_comment", limit: 80, comment: "Description of the replicated object"
    t.integer "status", precision: 38, comment: "Status of the last create or alter request on the local object"
    t.integer "genpackage", precision: 38, comment: "Status of whether the object needs to generate replication package"
    t.integer "genplogid", precision: 38, comment: "Log id of message sent for generating package support"
    t.integer "gentrigger", precision: 38, comment: "Status of whether the object needs to generate replication trigger"
    t.integer "gentlogid", precision: 38, comment: "Log id of message sent for generating trigger support"
    t.string "gowner", limit: 30, comment: "Owner of the object's object group"
    t.string "gname", limit: 30, comment: "Name of the object's object group"
    t.raw "flag", limit: 4, default: "00000000", comment: "Information about replicated object"
    t.index ["gname", "gowner"], name: "repcat$_repobject_prnt_idx"
    t.index ["gname", "oname", "type", "gowner"], name: "repcat$_repobject_gname"
  end

  create_table "repcat$_repprop", primary_key: ["sname", "oname", "type", "dblink"], comment: "Propagation information about replicated objects", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Name of the object owner"
    t.string "oname", limit: 30, null: false, comment: "Name of the object"
    t.integer "type", precision: 38, null: false, comment: "Type of the object"
    t.string "dblink", limit: 128, null: false, comment: "Destination database for propagation"
    t.integer "how", precision: 38, comment: "Propagation choice for the destination database"
    t.string "propagate_comment", limit: 80, comment: "Description of the propagation choice"
    t.decimal "delivery_order", comment: "Value of delivery order when the master was added"
    t.decimal "recipient_key", comment: "Recipient key for sname and oname, used in joining with def$_aqcall"
    t.raw "extension_id", limit: 16, default: "00", comment: "Identifier of any active extension request"
    t.index ["dblink", "how", "extension_id", "recipient_key"], name: "repcat$_repprop_dblink_how"
    t.index ["recipient_key"], name: "repcat$_repprop_key_index"
    t.index ["sname", "dblink"], name: "repcat$_repprop_prnt2_idx"
    t.index ["sname", "oname", "type"], name: "repcat$_repprop_prnt_idx"
  end

  create_table "repcat$_repschema", primary_key: ["sname", "dblink", "gowner"], comment: "N-way replication information", force: :cascade do |t|
    t.string "gowner", limit: 30, default: "PUBLIC", null: false, comment: "Owner of the replicated object group"
    t.string "sname", limit: 30, null: false, comment: "Name of the replicated object group"
    t.string "dblink", limit: 128, null: false, comment: "A database site replicating the object group"
    t.string "masterdef", limit: 1, comment: "Is the database the master definition site for the replicated object group"
    t.string "snapmaster", limit: 1, comment: "For a snapshot site, is this the current refresh_master"
    t.string "master_comment", limit: 80, comment: "Description of the database site"
    t.string "master", limit: 1, comment: "Redundant information from repcat$_repcat.master"
    t.decimal "prop_updates", default: "0.0", comment: "Number of requested updates for master in repcat$_repprop"
    t.string "my_dblink", limit: 1, comment: "A sanity check after import: is this master the current site"
    t.raw "extension_id", limit: 16, default: "00", comment: "Dummy column for foreign key"
    t.index ["dblink", "extension_id"], name: "repcat$_repschema_dest_idx"
    t.index ["sname", "gowner"], name: "repcat$_repschema_prnt_idx"
  end

  create_table "repcat$_resol_stats_control", primary_key: ["sname", "oname"], comment: "Information about statistics collection for conflict resolutions for all replicated tables in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of replicated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the replicated object"
    t.date "created", null: false, comment: "Timestamp for which statistics collection was first started"
    t.integer "status", precision: 38, null: false, comment: "Status of statistics collection: ACTIVE, CANCELLED"
    t.date "status_update_date", null: false, comment: "Timestamp for which the status was last updated"
    t.date "purged_date", comment: "Timestamp for the last purge of statistics data"
    t.date "last_purge_start_date", comment: "The last start date of the statistics purging date range"
    t.date "last_purge_end_date", comment: "The last end date of the statistics purging date range"
  end

  create_table "repcat$_resolution", primary_key: ["sname", "oname", "conflict_type_id", "reference_name", "sequence_no"], comment: "Description of all conflict resolutions in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of replicated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the replicated object"
    t.integer "conflict_type_id", precision: 38, null: false, comment: "Type of conflict"
    t.string "reference_name", limit: 30, null: false, comment: "Table name, unique constraint name, or column group name"
    t.decimal "sequence_no", null: false, comment: "Ordering on resolution"
    t.string "method_name", limit: 80, null: false, comment: "Name of the conflict resolution method"
    t.string "function_name", limit: 92, null: false, comment: "Name of the resolution function"
    t.string "priority_group", limit: 30, comment: "Name of the priority group used in conflict resolution"
    t.string "resolution_comment", limit: 80, comment: "Description of the conflict resolution"
    t.index ["conflict_type_id", "method_name"], name: "repcat$_resolution_f3_idx"
    t.index ["sname", "oname", "conflict_type_id", "reference_name"], name: "repcat$_resolution_idx2"
  end

  create_table "repcat$_resolution_method", primary_key: ["conflict_type_id", "method_name"], comment: "All conflict resolution methods in the database", force: :cascade do |t|
    t.integer "conflict_type_id", precision: 38, null: false, comment: "Type of conflict"
    t.string "method_name", limit: 80, null: false, comment: "Name of the conflict resolution method"
  end

  create_table "repcat$_resolution_statistics", id: false, comment: "Statistics for conflict resolutions for all replicated tables in the database", force: :cascade do |t|
    t.string "sname", limit: 30, null: false, comment: "Owner of replicated object"
    t.string "oname", limit: 30, null: false, comment: "Name of the replicated object"
    t.integer "conflict_type_id", precision: 38, null: false, comment: "Type of conflict"
    t.string "reference_name", limit: 30, null: false, comment: "Table name, unique constraint name, or column group name"
    t.string "method_name", limit: 80, null: false, comment: "Name of the conflict resolution method"
    t.string "function_name", limit: 92, null: false, comment: "Name of the resolution function"
    t.string "priority_group", limit: 30, comment: "Name of the priority group used in conflict resolution"
    t.date "resolved_date", null: false, comment: "Timestamp for the resolution of the conflict"
    t.string "primary_key_value", limit: 2000, null: false, comment: "Primary key of the replicated row (character data)"
    t.index ["sname", "oname", "resolved_date", "conflict_type_id", "reference_name", "method_name", "function_name", "priority_group"], name: "repcat$_resolution_stats_n1"
  end

  create_table "repcat$_runtime_parms", id: false, force: :cascade do |t|
    t.decimal "runtime_parm_id", comment: "Primary key of the parameter values table."
    t.string "parameter_name", limit: 30, comment: "Name of the parameter."
    t.text "parm_value", comment: "Parameter value."
    t.index ["runtime_parm_id", "parameter_name"], name: "repcat$_runtime_parms_pk", unique: true
  end

  create_table "repcat$_site_objects", id: false, comment: "Table for maintaining database objects deployed at a site.", force: :cascade do |t|
    t.decimal "template_site_id", null: false, comment: "Internal primary key of the template sites table."
    t.string "sname", limit: 30, comment: "Schema containing the deployed database object."
    t.string "oname", limit: 30, null: false, comment: "Name of the deployed database object."
    t.decimal "object_type_id", null: false, comment: "Internal ID of the object type of the deployed database object."
    t.index ["template_site_id", "oname", "object_type_id", "sname"], name: "repcat$_site_objects_u1", unique: true
    t.index ["template_site_id"], name: "repcat$_site_objects_n1"
  end

  create_table "repcat$_sites_new", primary_key: ["extension_id", "gowner", "gname", "dblink"], comment: "Information about new masters for replication extension", force: :cascade do |t|
    t.raw "extension_id", limit: 16, null: false, comment: "Globally unique identifier for replication extension"
    t.string "gowner", limit: 30, null: false, comment: "Owner of the object group"
    t.string "gname", limit: 30, null: false, comment: "Name of the replicated object group"
    t.string "dblink", limit: 128, null: false, comment: "A database site that will replicate the object group"
    t.string "full_instantiation", limit: 1, comment: "Y if the database uses full-database export or change-based recovery"
    t.decimal "master_status", comment: "Instantiation status of the new master"
    t.index ["extension_id"], name: "repcat$_sites_new_fk1_idx"
    t.index ["gname", "gowner"], name: "repcat$_sites_new_fk2_idx"
  end

  create_table "repcat$_snapgroup", id: false, comment: "Snapshot repgroup registration information", force: :cascade do |t|
    t.string "gowner", limit: 30, default: "PUBLIC", comment: "Owner of the snapshot repgroup"
    t.string "gname", limit: 30, comment: "Name of the snapshot repgroup"
    t.string "dblink", limit: 128, comment: "Database site of the snapshot repgroup"
    t.string "group_comment", limit: 80, comment: "Description of the snapshot repgroup"
    t.decimal "rep_type", comment: "Identifier of flavor at snapshot"
    t.decimal "flavor_id"
    t.index ["gname", "dblink", "gowner"], name: "i_repcat$_snapgroup1", unique: true
  end

  create_table "repcat$_template_objects", primary_key: "template_object_id", id: { type: :decimal, comment: "Internal primary key of the REPCAT$_TEMPLATE_OBJECTS table." }, force: :cascade do |t|
    t.decimal "refresh_template_id", null: false, comment: "Internal primary key of the REPCAT$_REFRESH_TEMPLATES table."
    t.string "object_name", limit: 30, null: false, comment: "Name of the database object."
    t.decimal "object_type", null: false, comment: "Type of database object."
    t.decimal "object_version#", comment: "Version# of database object of TYPE."
    t.text "ddl_text", comment: "DDL string for creating the object or WHERE clause for snapshot query."
    t.string "master_rollback_seg", limit: 30, comment: "Rollback segment for use during snapshot refreshes."
    t.string "derived_from_sname", limit: 30, comment: "Schema name of schema containing object this was derived from."
    t.string "derived_from_oname", limit: 30, comment: "Object name of object this object was derived from."
    t.decimal "flavor_id", comment: "Foreign key to the REPCAT$_FLAVORS table."
    t.string "schema_name", limit: 30, comment: "Schema containing the object."
    t.decimal "ddl_num", default: "1.0", null: false, comment: "Order of ddls to execute."
    t.decimal "template_refgroup_id", default: "0.0", null: false, comment: "Internal ID of the refresh group to contain the object."
    t.raw "flags", limit: 255, comment: "Internal flags for the object."
    t.string "spare1", limit: 4000, comment: "Reserved for future use."
    t.index ["object_name", "object_type", "refresh_template_id", "schema_name", "ddl_num"], name: "repcat$_template_objects_u1", unique: true
    t.index ["refresh_template_id", "object_name", "schema_name", "object_type"], name: "repcat$_template_objects_n2"
    t.index ["refresh_template_id", "object_type"], name: "repcat$_template_objects_n1"
  end

  create_table "repcat$_template_parms", primary_key: "template_parameter_id", id: { type: :decimal, comment: "Internal primary key of the REPCAT$_TEMPLATE_PARMS table." }, force: :cascade do |t|
    t.decimal "refresh_template_id", null: false, comment: "Internal primary key of the REPCAT$_REFRESH_TEMPLATES table."
    t.string "parameter_name", limit: 30, null: false, comment: "name of the parameter."
    t.text "default_parm_value", comment: "Default value for the parameter."
    t.string "prompt_string", limit: 2000, comment: "String for use in prompting for parameter values."
    t.string "user_override", limit: 1, default: "Y", comment: "User override flag."
    t.index ["refresh_template_id", "parameter_name"], name: "repcat$_template_parms_u1", unique: true
  end

  create_table "repcat$_template_refgroups", primary_key: "refresh_group_id", id: { type: :decimal, comment: "Internal primary key of the refresh groups table." }, comment: "Table for maintaining refresh group information for template.", force: :cascade do |t|
    t.string "refresh_group_name", limit: 30, null: false, comment: "Name of the refresh group"
    t.decimal "refresh_template_id", null: false, comment: "Primary key of the template containing the refresh group."
    t.string "rollback_seg", limit: 30, comment: "Name of the rollback segment to use during refresh."
    t.string "start_date", limit: 200, comment: "Refresh start date."
    t.string "interval", limit: 200, comment: "Refresh interval."
    t.index ["refresh_group_name"], name: "repcat$_template_refgroups_n1"
    t.index ["refresh_template_id"], name: "repcat$_template_refgroups_n2"
  end

  create_table "repcat$_template_sites", primary_key: "template_site_id", id: { type: :decimal, comment: "Internal primary key of the REPCAT$_TEMPLATE_SITES table." }, force: :cascade do |t|
    t.string "refresh_template_name", limit: 30, null: false, comment: "Name of the refresh group template."
    t.string "refresh_group_name", limit: 30, comment: "Name of the refresh group to create during instantiation."
    t.string "template_owner", limit: 30, comment: "Owner of the refresh group template."
    t.string "user_name", limit: 30, null: false, comment: "Database user name."
    t.string "site_name", limit: 128, comment: "Name of the site that has instantiated the template."
    t.decimal "repapi_site_id", comment: "Name of the site that has instantiated the template."
    t.decimal "status", null: false, comment: "Obsolete - do not use."
    t.decimal "refresh_template_id", comment: "Obsolete - do not use."
    t.decimal "user_id", comment: "Obsolete - do not use."
    t.date "instantiation_date", comment: "Date template was instantiated."
    t.index ["refresh_template_name", "user_name", "site_name", "repapi_site_id"], name: "repcat$_template_sites_u1", unique: true
  end

  create_table "repcat$_template_status", primary_key: "template_status_id", id: { type: :decimal, comment: "Internal primary key for the template status table." }, comment: "Table for template status and template status codes.", force: :cascade do |t|
    t.string "status_type_name", limit: 100, null: false, comment: "User friendly name for the template status."
  end

  create_table "repcat$_template_targets", primary_key: "template_target_id", id: { type: :decimal, comment: "Internal primary key of the template targets table." }, comment: "Internal table for tracking potential target databases for templates.", force: :cascade do |t|
    t.string "target_database", limit: 128, null: false, comment: "Global identifier of the target database."
    t.string "target_comment", limit: 2000, comment: "Comment on the target database."
    t.string "connect_string", limit: 4000, comment: "The connection descriptor used to connect to the target database."
    t.string "spare1", limit: 4000, comment: "The spare column"
    t.index ["target_database"], name: "repcat$_template_targets_u1", unique: true
  end

  create_table "repcat$_template_types", primary_key: "template_type_id", id: { type: :decimal, comment: "Internal primary key of the template types table." }, comment: "Internal table for maintaining types of templates.", force: :cascade do |t|
    t.string "template_description", limit: 200, comment: "Description of the template type."
    t.raw "flags", limit: 255, comment: "Bitmap flags controlling each type of template."
    t.string "spare1", limit: 4000, comment: "Reserved for future expansion."
  end

  create_table "repcat$_user_authorizations", primary_key: "user_authorization_id", id: { type: :decimal, comment: "Internal primary key of the REPCAT$_USER_AUTHORIZATIONS table." }, force: :cascade do |t|
    t.decimal "user_id", null: false, comment: "Database user id."
    t.decimal "refresh_template_id", null: false, comment: "Internal primary key of the REPCAT$_REFRESH_TEMPLATES table."
    t.index ["refresh_template_id"], name: "repcat$_user_authorizations_n1"
    t.index ["user_id", "refresh_template_id"], name: "repcat$_user_authorizations_u1", unique: true
  end

  create_table "repcat$_user_parm_values", primary_key: "user_parameter_id", id: { type: :decimal, comment: "Internal primary key of the REPCAT$_USER_PARM_VALUES table." }, force: :cascade do |t|
    t.decimal "template_parameter_id", null: false, comment: "Internal primary key of the REPCAT$_TEMPLATE_PARMS table."
    t.decimal "user_id", null: false, comment: "Database user id."
    t.text "parm_value", comment: "Value of the parameter for this user."
    t.index ["template_parameter_id", "user_id"], name: "repcat$_user_parm_values_u1", unique: true
  end

# Could not dump table "sqlplus_product_profile" because of following StandardError
#   Unknown type 'LONG' for column 'long_value'

  add_foreign_key "aq$_internet_agent_privs", "aq$_internet_agents", column: "agent_name", primary_key: "agent_name", name: "agent_must_be_created", on_delete: :cascade
  add_foreign_key "def$_calldest", "def$_destination", column: "catchup", primary_key: "catchup", name: "def$_call_destination"
  add_foreign_key "def$_calldest", "def$_destination", column: "dblink", primary_key: "dblink", name: "def$_call_destination"
  add_foreign_key "mview$_adv_ajg", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_ajg_fk"
  add_foreign_key "mview$_adv_basetable", "mview$_adv_workload", column: "queryid#", primary_key: "queryid#", name: "mview$_adv_basetable_fk"
  add_foreign_key "mview$_adv_clique", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_clique_fk"
  add_foreign_key "mview$_adv_eligible", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_eligible_fk"
  add_foreign_key "mview$_adv_exceptions", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_exception_fk"
  add_foreign_key "mview$_adv_filterinstance", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_filterinstance_fk"
  add_foreign_key "mview$_adv_fjg", "mview$_adv_ajg", column: "ajgid#", primary_key: "ajgid#", name: "mview$_adv_fjg_fk"
  add_foreign_key "mview$_adv_gc", "mview$_adv_fjg", column: "fjgid#", primary_key: "fjgid#", name: "mview$_adv_gc_fk"
  add_foreign_key "mview$_adv_info", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_info_fk"
  add_foreign_key "mview$_adv_journal", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_journal_fk"
  add_foreign_key "mview$_adv_level", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_level_fk"
  add_foreign_key "mview$_adv_output", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_output_fk"
  add_foreign_key "mview$_adv_rollup", "mview$_adv_level", column: "clevelid#", primary_key: "levelid#", name: "mview$_adv_rollup_cfk"
  add_foreign_key "mview$_adv_rollup", "mview$_adv_level", column: "plevelid#", primary_key: "levelid#", name: "mview$_adv_rollup_pfk"
  add_foreign_key "mview$_adv_rollup", "mview$_adv_level", column: "runid#", primary_key: "runid#", name: "mview$_adv_rollup_cfk"
  add_foreign_key "mview$_adv_rollup", "mview$_adv_level", column: "runid#", primary_key: "runid#", name: "mview$_adv_rollup_pfk"
  add_foreign_key "mview$_adv_rollup", "mview$_adv_log", column: "runid#", primary_key: "runid#", name: "mview$_adv_rollup_fk"
  add_foreign_key "repcat$_audit_column", "repcat$_audit_attribute", column: "attribute", primary_key: "attribute", name: "repcat$_audit_column_f1"
  add_foreign_key "repcat$_audit_column", "repcat$_conflict", column: "base_conflict_type_id", primary_key: "conflict_type_id", name: "repcat$_audit_column_f2"
  add_foreign_key "repcat$_audit_column", "repcat$_conflict", column: "base_oname", primary_key: "oname", name: "repcat$_audit_column_f2"
  add_foreign_key "repcat$_audit_column", "repcat$_conflict", column: "base_reference_name", primary_key: "reference_name", name: "repcat$_audit_column_f2"
  add_foreign_key "repcat$_audit_column", "repcat$_conflict", column: "base_sname", primary_key: "sname", name: "repcat$_audit_column_f2"
  add_foreign_key "repcat$_ddl", "repcat$_repcatlog", column: "log_id", name: "repcat$_ddl_prnt", on_delete: :cascade
  add_foreign_key "repcat$_ddl", "repcat$_repcatlog", column: "master", primary_key: "master", name: "repcat$_ddl_prnt", on_delete: :cascade
  add_foreign_key "repcat$_ddl", "repcat$_repcatlog", column: "role", primary_key: "role", name: "repcat$_ddl_prnt", on_delete: :cascade
  add_foreign_key "repcat$_ddl", "repcat$_repcatlog", column: "source", primary_key: "source", name: "repcat$_ddl_prnt", on_delete: :cascade
  add_foreign_key "repcat$_flavor_objects", "repcat$_flavors", column: "flavor_id", primary_key: "flavor_id", name: "repcat$_flavor_objects_fk2", on_delete: :cascade
  add_foreign_key "repcat$_flavor_objects", "repcat$_flavors", column: "gname", primary_key: "gname", name: "repcat$_flavor_objects_fk2", on_delete: :cascade
  add_foreign_key "repcat$_flavor_objects", "repcat$_flavors", column: "gowner", primary_key: "gowner", name: "repcat$_flavor_objects_fk2", on_delete: :cascade
  add_foreign_key "repcat$_flavor_objects", "repcat$_repcat", column: "gname", primary_key: "sname", name: "repcat$_flavor_objects_fk1", on_delete: :cascade
  add_foreign_key "repcat$_flavor_objects", "repcat$_repcat", column: "gowner", primary_key: "gowner", name: "repcat$_flavor_objects_fk1", on_delete: :cascade
  add_foreign_key "repcat$_flavors", "repcat$_repcat", column: "gname", primary_key: "sname", name: "repcat$_flavors_fk1", on_delete: :cascade
  add_foreign_key "repcat$_flavors", "repcat$_repcat", column: "gowner", primary_key: "gowner", name: "repcat$_flavors_fk1", on_delete: :cascade
  add_foreign_key "repcat$_generated", "repcat$_repobject", column: "base_oname", primary_key: "oname", name: "repcat$_repgen_prnt2", on_delete: :cascade
  add_foreign_key "repcat$_generated", "repcat$_repobject", column: "base_sname", primary_key: "sname", name: "repcat$_repgen_prnt2", on_delete: :cascade
  add_foreign_key "repcat$_generated", "repcat$_repobject", column: "base_type", primary_key: "type", name: "repcat$_repgen_prnt2", on_delete: :cascade
  add_foreign_key "repcat$_generated", "repcat$_repobject", column: "oname", primary_key: "oname", name: "repcat$_repgen_prnt", on_delete: :cascade
  add_foreign_key "repcat$_generated", "repcat$_repobject", column: "sname", primary_key: "sname", name: "repcat$_repgen_prnt", on_delete: :cascade
  add_foreign_key "repcat$_generated", "repcat$_repobject", column: "type", primary_key: "type", name: "repcat$_repgen_prnt", on_delete: :cascade
  add_foreign_key "repcat$_grouped_column", "repcat$_column_group", column: "group_name", primary_key: "group_name", name: "repcat$_grouped_column_f1"
  add_foreign_key "repcat$_grouped_column", "repcat$_column_group", column: "oname", primary_key: "oname", name: "repcat$_grouped_column_f1"
  add_foreign_key "repcat$_grouped_column", "repcat$_column_group", column: "sname", primary_key: "sname", name: "repcat$_grouped_column_f1"
  add_foreign_key "repcat$_instantiation_ddl", "repcat$_refresh_templates", column: "refresh_template_id", primary_key: "refresh_template_id", name: "repcat$_instantiation_ddl_fk1", on_delete: :cascade
  add_foreign_key "repcat$_key_columns", "repcat$_repobject", column: "oname", primary_key: "oname", name: "repcat$_key_columns_prnt", on_delete: :cascade
  add_foreign_key "repcat$_key_columns", "repcat$_repobject", column: "sname", primary_key: "sname", name: "repcat$_key_columns_prnt", on_delete: :cascade
  add_foreign_key "repcat$_key_columns", "repcat$_repobject", column: "type", primary_key: "type", name: "repcat$_key_columns_prnt", on_delete: :cascade
  add_foreign_key "repcat$_object_parms", "repcat$_template_objects", column: "template_object_id", primary_key: "template_object_id", name: "repcat$_object_parms_fk2", on_delete: :cascade
  add_foreign_key "repcat$_object_parms", "repcat$_template_parms", column: "template_parameter_id", primary_key: "template_parameter_id", name: "repcat$_object_parms_fk1"
  add_foreign_key "repcat$_parameter_column", "repcat$_resolution", column: "conflict_type_id", primary_key: "conflict_type_id", name: "repcat$_parameter_column_f1"
  add_foreign_key "repcat$_parameter_column", "repcat$_resolution", column: "oname", primary_key: "oname", name: "repcat$_parameter_column_f1"
  add_foreign_key "repcat$_parameter_column", "repcat$_resolution", column: "reference_name", primary_key: "reference_name", name: "repcat$_parameter_column_f1"
  add_foreign_key "repcat$_parameter_column", "repcat$_resolution", column: "sequence_no", primary_key: "sequence_no", name: "repcat$_parameter_column_f1"
  add_foreign_key "repcat$_parameter_column", "repcat$_resolution", column: "sname", primary_key: "sname", name: "repcat$_parameter_column_f1"
  add_foreign_key "repcat$_priority", "repcat$_priority_group", column: "priority_group", primary_key: "priority_group", name: "repcat$_priority_f1"
  add_foreign_key "repcat$_priority", "repcat$_priority_group", column: "sname", primary_key: "sname", name: "repcat$_priority_f1"
  add_foreign_key "repcat$_refresh_templates", "repcat$_template_status", column: "template_status_id", primary_key: "template_status_id", name: "repcat$_refresh_templates_fk2"
  add_foreign_key "repcat$_refresh_templates", "repcat$_template_types", column: "template_type_id", primary_key: "template_type_id", name: "repcat$_refresh_templates_fk1"
  add_foreign_key "repcat$_repcolumn", "repcat$_repobject", column: "oname", primary_key: "oname", name: "repcat$_repcolumn_fk", on_delete: :cascade
  add_foreign_key "repcat$_repcolumn", "repcat$_repobject", column: "sname", primary_key: "sname", name: "repcat$_repcolumn_fk", on_delete: :cascade
  add_foreign_key "repcat$_repcolumn", "repcat$_repobject", column: "type", primary_key: "type", name: "repcat$_repcolumn_fk", on_delete: :cascade
  add_foreign_key "repcat$_repgroup_privs", "repcat$_repcat", column: "gname", primary_key: "sname", name: "repcat$_repgroup_privs_fk", on_delete: :cascade
  add_foreign_key "repcat$_repgroup_privs", "repcat$_repcat", column: "gowner", primary_key: "gowner", name: "repcat$_repgroup_privs_fk", on_delete: :cascade
  add_foreign_key "repcat$_repobject", "repcat$_repcat", column: "gname", primary_key: "sname", name: "repcat$_repobject_prnt", on_delete: :cascade
  add_foreign_key "repcat$_repobject", "repcat$_repcat", column: "gowner", primary_key: "gowner", name: "repcat$_repobject_prnt", on_delete: :cascade
  add_foreign_key "repcat$_repprop", "repcat$_repobject", column: "oname", primary_key: "oname", name: "repcat$_repprop_prnt", on_delete: :cascade
  add_foreign_key "repcat$_repprop", "repcat$_repobject", column: "sname", primary_key: "sname", name: "repcat$_repprop_prnt", on_delete: :cascade
  add_foreign_key "repcat$_repprop", "repcat$_repobject", column: "type", primary_key: "type", name: "repcat$_repprop_prnt", on_delete: :cascade
  add_foreign_key "repcat$_repschema", "def$_destination", column: "dblink", primary_key: "dblink", name: "repcat$_repschema_dest"
  add_foreign_key "repcat$_repschema", "def$_destination", column: "extension_id", primary_key: "catchup", name: "repcat$_repschema_dest"
  add_foreign_key "repcat$_repschema", "repcat$_repcat", column: "gowner", primary_key: "gowner", name: "repcat$_repschema_prnt", on_delete: :cascade
  add_foreign_key "repcat$_repschema", "repcat$_repcat", column: "sname", primary_key: "sname", name: "repcat$_repschema_prnt", on_delete: :cascade
  add_foreign_key "repcat$_resolution", "repcat$_conflict", column: "conflict_type_id", primary_key: "conflict_type_id", name: "repcat$_resolution_f3"
  add_foreign_key "repcat$_resolution", "repcat$_conflict", column: "oname", primary_key: "oname", name: "repcat$_resolution_f3"
  add_foreign_key "repcat$_resolution", "repcat$_conflict", column: "reference_name", primary_key: "reference_name", name: "repcat$_resolution_f3"
  add_foreign_key "repcat$_resolution", "repcat$_conflict", column: "sname", primary_key: "sname", name: "repcat$_resolution_f3"
  add_foreign_key "repcat$_resolution", "repcat$_resolution_method", column: "conflict_type_id", primary_key: "conflict_type_id", name: "repcat$_resolution_f1"
  add_foreign_key "repcat$_resolution", "repcat$_resolution_method", column: "method_name", primary_key: "method_name", name: "repcat$_resolution_f1"
  add_foreign_key "repcat$_site_objects", "repcat$_object_types", column: "object_type_id", primary_key: "object_type_id", name: "repcat$_site_objects_fk1"
  add_foreign_key "repcat$_site_objects", "repcat$_template_sites", column: "template_site_id", primary_key: "template_site_id", name: "repcat$_site_object_fk2", on_delete: :cascade
  add_foreign_key "repcat$_sites_new", "repcat$_extension", column: "extension_id", primary_key: "extension_id", name: "repcat$_sites_new_fk1", on_delete: :cascade
  add_foreign_key "repcat$_sites_new", "repcat$_repcat", column: "gname", primary_key: "sname", name: "repcat$_sites_new_fk2", on_delete: :cascade
  add_foreign_key "repcat$_sites_new", "repcat$_repcat", column: "gowner", primary_key: "gowner", name: "repcat$_sites_new_fk2", on_delete: :cascade
  add_foreign_key "repcat$_template_objects", "repcat$_object_types", column: "object_type", primary_key: "object_type_id", name: "repcat$_template_objects_fk3"
  add_foreign_key "repcat$_template_objects", "repcat$_refresh_templates", column: "refresh_template_id", primary_key: "refresh_template_id", name: "repcat$_template_objects_fk1", on_delete: :cascade
  add_foreign_key "repcat$_template_parms", "repcat$_refresh_templates", column: "refresh_template_id", primary_key: "refresh_template_id", name: "repcat$_template_parms_fk1", on_delete: :cascade
  add_foreign_key "repcat$_template_refgroups", "repcat$_refresh_templates", column: "refresh_template_id", primary_key: "refresh_template_id", name: "repcat$_template_refgroups_fk1", on_delete: :cascade
  add_foreign_key "repcat$_user_authorizations", "repcat$_refresh_templates", column: "refresh_template_id", primary_key: "refresh_template_id", name: "repcat$_user_authorization_fk2", on_delete: :cascade
  add_foreign_key "repcat$_user_parm_values", "repcat$_template_parms", column: "template_parameter_id", primary_key: "template_parameter_id", name: "repcat$_user_parm_values_fk1", on_delete: :cascade
  add_synonym "catalog", "sys.catalog", force: true
  add_synonym "col", "sys.col", force: true
  add_synonym "product_user_profile", "system.sqlplus_product_profile", force: true
  add_synonym "publicsyn", "sys.publicsyn", force: true
  add_synonym "syscatalog", "sys.syscatalog", force: true
  add_synonym "sysfiles", "sys.sysfiles", force: true
  add_synonym "tab", "sys.tab", force: true
  add_synonym "tabquotas", "sys.tabquotas", force: true

end
