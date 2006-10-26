package t::Config;
use strict;
use warnings;

sub instance { bless { }, shift }

sub time_zone { 'Asia/Tokyo' }

1;
