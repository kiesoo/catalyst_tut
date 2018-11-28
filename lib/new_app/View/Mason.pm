package new_app::View::Mason;

use strict;
use warnings;

use parent 'Catalyst::View::Mason';

__PACKAGE__->config( use_match => 0,
                     comp_root => [
                        ['main' => new_app->path_to('root', 'src') ],
                        ['views' => new_app->path_to('root', 'src', 'views') ],
                        ['components' => new_app->path_to('root', 'src', 'components') ]
                     ],
                     template_extension => '.mhtml',
                     always_append_template_extension => 0,
                     static_source => 0, # check is source has changed
                     ignore_warnings_expr =>'.*is experimental.*',
                     data_dir   =>'/tmp/mason',
            );

=head1 NAME

new_app::View::Mason - Mason View Component for new_app

=head1 DESCRIPTION

Mason View Component for new_app

=head1 SEE ALSO

L<new_app>, L<HTML::Mason>

=head1 AUTHOR

admin

=head1 LICENSE

This library is free software . You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
