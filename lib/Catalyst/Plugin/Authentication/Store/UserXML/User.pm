package Catalyst::Plugin::Authentication::Store::UserXML::User;

use strict;
use warnings;

use Moose;
use Path::Class;
use XML::LibXML;
use Authen::Passphrase;

extends 'Catalyst::Authentication::User';

has 'xml_filename' => (is=>'ro', isa=>'Path::Class::File', required => 1);
has 'xml' => (is=>'ro', isa=>'XML::LibXML::Document', lazy => 1, builder => '_build_xml');

use overload '""' => sub { shift->username }, fallback => 1;

sub _build_xml {
    my $self = shift;
    my $xml_file = $self->xml_filename;

    return XML::LibXML->load_xml(
        location => $xml_file
    );
}

sub get_node {
    my ($self, $element_name) = @_;
    my $dom = $self->xml->documentElement;

    foreach my $node ($dom->findnodes('*')) {
        next if $element_name ne $node->nodeName;
        return $node;
    }

    return undef;
}

sub get_node_text {
    my ($self, $element_name) = @_;

    my $node = $self->get_node($element_name);
    return undef unless $node;
    return $node->textContent;
}

*id = *username;
sub username      { return $_[0]->get_node_text('username'); }
sub password_hash { return $_[0]->get_node_text('password'); }

sub supported_features {
	return {
        password => {
            self_check => 1,
		},
        session => 1,
        roles => 1,
	};
}

sub check_password {
	my ( $self, $secret ) = @_;
    my $password_hash = $self->password_hash;

    return
        Authen::Passphrase
        ->from_rfc2307($password_hash)
        ->match($secret)
    ;
}

sub roles {
	my $self = shift;

    my $node = $self->get_node('roles');
    return () unless $node;

    my @roles;
    foreach my $role_node ($node->findnodes('role')) {
        push(@roles, $role_node->textContent)
    }

    return @roles;
}

sub for_session {
    my $self = shift;
    return $self->username;
}

1;


__END__

=head1 SYNOPSIS

    my $user = Catalyst::Plugin::Authentication::Store::UserXML::User->new({
        xml_filename => $file
    });
    say $user->username;
    die unless $user->check_password('secret');

=head1 EXAMPLE

    <!-- userxml-folder/some-username -->
    <user>
        <username>some-username</username>
        <password>{CLEARTEXT}secret</password>
    </user>

=head1 SEE ALSO

L<Authen::Passphrase>

=cut
