package WWW::Synonyms;
use strict;
use warnings;
use URI;
use URI::QueryParam;
use JSON::MaybeXS;
use Data::Dumper;

use Carp;

my %_lang_mapping = (
    it => 'it_IT',
    fr => 'fr_FR',
    de => 'de_DE',
    en => 'en_US',
    el => 'el_GR',
    es => 'es_ES',
    de => 'de_DE',
    no => 'no_NO',
    pt => 'pt_PT',
    ro => 'ro_RO',
    ru => 'ru_RU',
    sk => 'sk_SK',
);

sub new {
    my ($class, %args) = @_;

    my $language     = $args{language} // 'en';
    my $api_language = $_lang_mapping{$language}
        // croak "langauge: '$language' is not supported.\nUse any of:\n"
        . join '', map "\t- $_\n", keys %_lang_mapping;

    my $base_uri = URI->new('http://thesaurus.altervista.org/thesaurus/v1');
    $base_uri->query_form(
        key      => $args{key} // croak('needs api key to work'),
        language => $api_language,
        output   => 'json',
    );

    return bless {
        language => $api_language,
        _ua       => $args{ua} // do {
            require LWP::UserAgent || croak "provide user agent or install 'LWP::UserAgent'";
            LWP::UserAgent->new;
        },
        _base_uri => $base_uri,
    }, $class;
}

sub get_synonyms {
    my ($self, $word, $cat) = @_;

    my $uri = $self->{_base_uri};

    $uri->query_param_append(word => $word);

    my $response = $self->{ua}->get($uri);

    return () unless $response->is_success;

    my $json = decode_json($response->decoded_content);

    my %cat_to_syns;
    for my $res (map $_->{list}, @{ $json->{response} }) {
        my $cat = $res->{category};
        if (defined $cat_to_syns{$cat}) {
            push @{$cat_to_syns{$cat}}, split /\|/, $res->{synonyms};
        }
        else {
            @{$cat_to_syns{$cat}} = split /\|/, $res->{synonyms};
        }
    }

    return defined $cat ? @{$cat_to_syns{$cat} // ()} : (map @$_,values %cat_to_syns);
}

return 1;
