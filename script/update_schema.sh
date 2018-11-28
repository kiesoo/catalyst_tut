#!/bin/bash 

dbicdump -o dump_directory=lib -o overwrite_changes=1 -o use_moose=1 new_app::Schema "dbi:mysql:database=myapp;" root parola_mea

# create model, run this from /projects/new_app
script/myapp_create.pl model APP DBIC::Schema new_app::Schema dbi:mysql:myapp root parola_mea