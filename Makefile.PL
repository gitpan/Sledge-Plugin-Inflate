use strict;
use warnings;
use inc::Module::Install;

name            'Sledge-Plugin-Inflate';
all_from        'lib/Sledge/Plugin/Inflate.pm';

use_test_base;

auto_install;
WriteAll;

