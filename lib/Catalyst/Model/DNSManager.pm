package Catalyst::Model::DNSManager;
use Moose;
use Class::Load qw/load_class/;
use namespace::autoclean;

extends 'Catalyst::Model';

has backend => (
    isa      => HashRef,
    is       => 'ro',
    required => 1,
);

has _backend_instance => (
    isa        => HashRef,
    is         => 'ro',
    lazy       => 1,
    builder    => '_build_backend_instance',
    traits     => ['Hash'],
    handles    => {
        get_backend        => 'get',
        available_backends => 'keys',
    },
);

has default_backend => (
    isa       => Str,
    is        => 'ro',
    predicate => 'has_default_backend',
);

sub ACCEPT_CONTEXT {
    my ( $self, $ctx ) = @_;

    if ( $ctx->stash->{dnsmanager_current_backend} ) {
        return $self->get_backend( $ctx->stash->{dnsmanager_current_backend} );
    }

    if ( $self->has_default_backend ) {
        return $self->get_backend( $self->default_backend );
    }

    return $self;
}

sub _build_backend_instance {
    my ($self) = @_;

    my %backend = %{ $self->backend };
    my %instance;

    for my $b ( keys %backend ) {
        my $class = load_class( 'Catalyst::Model::DNSManager::Backend::' . $b );
        $instance{$b} = $class->new( $backend{$b} );
    }

    return \%instance;
}

__PACKAGE__->meta->make_immutable;

1;
