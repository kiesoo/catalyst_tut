use utf8;
package new_app::Schema::Result::Book;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

new_app::Schema::Result::Book

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<books>

=cut

__PACKAGE__->table("books");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 rating

  data_type: 'integer'
  is_nullable: 1

=head2 created

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "rating",
  { data_type => "integer", is_nullable => 1 },
  "created",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 book_authors

Type: has_many

Related object: L<new_app::Schema::Result::BookAuthor>

=cut

__PACKAGE__->has_many(
  "book_authors",
  "new_app::Schema::Result::BookAuthor",
  { "foreign.book_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 authors

Type: many_to_many

Composing rels: L</book_authors> -> author

=cut

__PACKAGE__->many_to_many("authors", "book_authors", "author");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2018-11-27 09:41:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sHwSAhc5TapNiBpl1p7YaQ


=head2 author_count
 
Return the number of authors for the current book.
 
=cut

sub author_count {
  my $self = shift();

  return $self->authors->count();
}


=head2 author_list

Return a comma-separated list of authors for the current book.

=cut

sub author_list {
  my $self = shift();

  return join(', ', map { $_->full_name() } $self->authors());
}
# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
