#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'WWW::Synonyms' ) || print "Bail out!\n";
}

diag( "Testing WWW::Synonyms $WWW::Synonyms::VERSION, Perl $], $^X" );
