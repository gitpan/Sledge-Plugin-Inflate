package t::TestPages;
use strict;
use warnings;
use base qw/Sledge::TestPages/;
use Sledge::Plugin::Inflate;

BEGIN {
    eval qq{
        use base qw(Sledge::TestPages);
        use YAML;
    };
    die $@ if $@;
}

__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ($self, ) = @_;
        $self->r->print(
            YAML::Dump(
                {
                    map { $_ => $self->tmpl->param($_) }
                        grep !/^(session|r|config)/,
                    $self->tmpl->param
                }
            )
        );
        $self->finished(1);
    }
);

my $x;
$x = $t::TestPages::TMPL_PATH = 't/';
$x = $t::TestPages::COOKIE_NAME = 'sid';
$ENV{HTTP_COOKIE}    = "sid=SIDSIDSIDSID";
$ENV{REQUEST_METHOD} = 'GET';
$ENV{QUERY_STRING}   = 'foo=bar';

1;
