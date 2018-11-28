use DBIx::Class::Schema::Loader qw/ make_schema_at rescan /;

make_schema_at(
    'new_app::Schema',
    {   debug => 1,
        dump_directory => 'lib/',
        components => ["InflateColumn::DateTime", "TimeStamp"],
        overwrite_modifications => 1,
        use_moose => 1,
    },
    [ 'dbi:mysql:myapp', 'root', 'bnoWtbk13#' ],
);
