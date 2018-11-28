use strict;
use warnings;

use new_app;

my $app = new_app->apply_default_middlewares(new_app->psgi_app);
$app;

