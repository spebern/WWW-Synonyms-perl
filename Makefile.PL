use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'WWW::Synonyms',
    AUTHOR           => q{spebern <bernhard@specht.net>},
    VERSION_FROM     => 'lib/WWW/Synonyms.pm',
    ABSTRACT_FROM    => 'lib/WWW/Synonyms.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        URI             => 0,
        URI::QueryParam => 0,
        JSON::MaybeXS   => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WWW-Synonyms-*' },
);
