package Catalyst::Model::DNSManager::Backend::DigitalOcean;
use Moose;
use namespace::autoclean;
use WebService::DigitalOcean;

has _instance => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        WebService::DigitalOcean->new(token => shift->token);
    },
    # TODO:
    # handles
);

has token => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

__PACKAGE__->meta->make_immutable;

1;
