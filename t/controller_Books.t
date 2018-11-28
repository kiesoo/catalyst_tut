use strict;
use warnings;
use Test::More;


use Catalyst::Test 'new_app';
use new_app::Controller::Books;

ok( request('/books')->is_success, 'Request should succeed' );
done_testing();
