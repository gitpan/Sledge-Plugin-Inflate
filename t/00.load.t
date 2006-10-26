use strict;
use warnings;
use Test::More tests => 1;

BEGIN {
    eval q[use Sledge::Registrar];
    plan skip_all => "Sledge::Registrar required for testing base" if $@;
};

sub mk_classdata { 'dummy for test' }
sub add_trigger { 'dummy for test' }

BEGIN {
use_ok( 'Sledge::Plugin::Inflate' );
}

diag( "Testing Sledge::Plugin::Inflate $Sledge::Plugin::Inflate::VERSION" );
