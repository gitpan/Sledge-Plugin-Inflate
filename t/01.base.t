use strict;
use warnings;
use Test::Base;
BEGIN {
    eval q[use Sledge::Registrar; use YAML; use Sledge::TestPages];
    plan skip_all => "YAML, Sledge::TestPages required for testing base" if $@;
};
use t::TestPages;
use t::Data::CD;

delimiters '===' => '***';

plan tests => 1*blocks;

filters(
    {
        query => [qw/chomp/],
    }
);

run {
    my $block = shift;

    $ENV{QUERY_STRING} = $block->query;

    no strict 'refs';
    local *{"t::TestPages::dispatch_test"} = eval $block->input; ## no critic
    die $@ if $@;

    my $pages = t::TestPages->new;
    $pages->dispatch('test');

    is($pages->output, $block->expected, $block->name);
};

__END__

=== customize rule(string)
*** query
foo=bar
*** input
sub {
    my $self = shift;

    my $proto = ref $self;
    $proto->add_inflate_rule(
        'dummy' => sub { 'DUMMY' },
        qr/dummy/ => sub { 'DUMMY' },
        foo => sub {
            my $self = shift;
            return $self->r->param('foo');
        }
    );

    $self->tmpl->param(foo => $self->r->inflate('foo'));
}
*** expected
---
foo: bar

=== customize rule(regexp)
*** query
foo_bar=baz
*** input
sub {
    my $self = shift;

    my $proto = ref $self;
    $proto->add_inflate_rule(
        'dummy' => sub { 'DUMMY' },
        qr/dummy/ => sub { 'DUMMY' },
        qr/(foo_.+)/ => sub {
            my $self = shift;
            return $self->r->param($1);
        },
    );

    $self->tmpl->param(foo_bar => $self->r->inflate('foo_bar'));
}
*** expected
---
foo_bar: baz

=== fail if not match the rule.
*** query
*** input
sub {
    my $self = shift;

    eval { $self->r->inflate('unknown') };
    my $err = $@;
    $err =~ s/at .+//g;
    $self->tmpl->param(err => $err);
}
*** expected
---
err: "unknown inflate rule : unknown \n"

