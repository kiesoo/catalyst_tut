package new_app::Controller::Books;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

new_app::Controller::Books - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 base
 
Can place common logic to start chained dispatch here.
 
=cut
 
sub base :Chained('/') :PathPart('books') :CaptureArgs(0) {
    my ($self, $c) = @_;
 
    # Store the ResultSet in stash so it's available for other methods
    $c->stash(resultset => $c->model('APP::Book'));
 
    # Print a message to the debug log
    $c->log->debug('*** INSIDE BASE METHOD ***');
}


=head2 object
 
Fetch the specified book object based on the book ID and store
it in the stash
 
=cut

sub object :Chained('base') :PathPart(id) :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash( object => $c->stash->{resultset}->find($id));

    $c->detach('/error_404') if !$c->stash->{object};

    $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched new_app::Controller::Books in Books.');
}


=head2 list

=cut

sub list :Local {
    my ( $self, $c ) = @_;

    $c->stash( books => [ $c->model("APP::Book")->all() ],
               template => 'books/list.mhtml' );
}


=head2 list_recent
 
List recently created books
 
=cut

sub list_recent :Chained('base') :PathPart('list_recent') :Args(1) {
    my ( $self, $c, $mins ) = @_;

    $c->stash( books => [
        $c->stash->{resultset}
            ->created_after( DateTime->now->subtract(minutes => $mins) )
        ],
               template => 'books/list.mhtml' );
}


=head2 list_recent_tcp
 
List recently created books
 
=cut

sub list_recent_tcp :Chained('base') :PathPart('list_recent_tcp') :Args(1) {
    my ( $self, $c, $mins ) = @_;

    $c->stash( books => [
        $c->model('APP::Book')
            ->created_after( DateTime->now->subtract(minutes => $mins) )
            ->title_like('tcp')
        ],
               template => 'books/list.mhtml' );
}

=head2 form_create
 
Display form to collect information for book to create
 
=cut

sub form_create :Chained('base') :PathPart('form_create') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( template => 'books/create_form.mhtml');
}


=head2 form_create_do
 
Take information from form and add to database
 
=cut

sub form_create_do :Chained('base') :PathPart('form_create_do') :Args(0) {
    my ( $self, $c ) = @_;

    my $title = $c->request->params->{title} || 'N/A';
    my $rating = $c->request->params->{rating}  || 'N/A';
    my $author_id = $c->request->params->{author_id} || '1';

    my $book = $c->stash->{resultset}->create({
        title => $title,
        rating => $rating,
    });

    $book->add_to_book_authors({author_id => $author_id});

    $c->stash( book => $book,
               template => 'books/create_done.mhtml');
}


=head2 create

=cut

sub create :Chained('base') :PathPart('create') :Args(3) {
    my ( $self, $c, $title, $rating, $author_id ) = @_;

    my $book = $c->model("APP::Book")->create({
            title  => $title,
            rating => $rating
        });

    $book->add_to_book_authors( { author_id => $author_id } );
    
#    $c->stash( book => $book,
#               template => '/books/create_done.mhtml');

    $c->stash->{status_msg} = "Book created!";

    $c->response->redirect( $c->uri_for(
        $self->action_for('list'),
        { status_msg => "Book created!" }
    ));
}


=head2 delete
 
Delete a book
 
=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{object}->delete();

    # Set a status message to be displayed at the top of the view
    $c->stash->{status_msg} = "Book deleted!";
 
    # Forward to the list action/method in this controller
    $c->response->redirect( $c->uri_for(
        $self->action_for('list'),
        { status_msg => "Book deleted!" }
    ));
}

=encoding utf8

=head1 AUTHOR

admin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
