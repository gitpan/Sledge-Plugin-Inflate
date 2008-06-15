use strict;
use warnings;
use inc::Module::Install;

name            'Sledge-Plugin-Inflate';
all_from        'lib/Sledge/Plugin/Inflate.pm';

test_requires 'Test::Base' => 0;
author_tests 'xt';

use_test_base;

auto_install;
WriteAll;

