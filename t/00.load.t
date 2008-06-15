use strict;
use warnings;
use Test::More;

BEGIN {
    eval q[use Sledge::Registrar];
    plan skip_all => "Sledge::Registrar required for testing base" if $@;
};

plan tests => 1;

sub mk_classdata { 'dummy for test' }
sub add_trigger { 'dummy for test' }

use_ok( 'Sledge::Plugin::Inflate' );

diag( "Testing Sledge::Plugin::Inflate $Sledge::Plugin::Inflate::VERSION" );
