package Catalyst::Plugin::Authentication::Store::UserXML;

use strict;
use warnings;

our $VERSION = '0.01';

use Catalyst::Plugin::Authentication::Store::UserXML::Folder;

sub setup {
    my $c = shift;

    my $config = $c->config->{authentication}{userxml} || {};
    my $folder = $config->{folder};
    die 'please set user xml folder in your configuration file ($c->config->{authentication}{userxml}{folder})'
        unless $folder;
    
    $folder = $c->path_to($folder)
        unless ref $folder;

    die $folder.' is not a folder'
        unless -d $folder;

    $c->default_auth_store(
        Catalyst::Plugin::Authentication::Store::UserXML::Folder->new({
            folder => $folder,
        })
    );

	$c->NEXT::setup(@_);
}

1;

__END__

=head1 NAME

Catalyst::Plugin::Authentication::Store::UserXML - Catalyst authentication storage using xml files

=head1 SYNOPSIS

    use Catalyst qw(
        ...
        Authentication
        Authentication::Store::UserXML
    );

    __PACKAGE__->config(
        'Plugin::Authentication' => {
            default_realm => 'members',
            members => {
                credential => {
                    class         => 'Password',
                    password_type => 'self_check',
                },
                store => {
                    class         => 'UserXML',
                }
            }
        },
        'authentication' => {
            'userxml' => {
                'folder' => 'members',
            }
        },
    );

    # later in controller (login)
    $c->authenticate({
        username => $c->req->param('username'),
        password => $c->req->param('password'),
    });

=head1 DESCRIPTION

Catalyst authentication storage using xml files in a folder.

=head1 SEE ALSO

L<Catalyst::Plugin::Authentication>
L<Catalyst::Plugin::Authentication::Store::UserXML::User>

=head1 AUTHOR

Jozef Kutej, C<< <jkutej at cpan.org> >>

=head1 CONTRIBUTORS
 
The following people have contributed to the File::is by committing their
code, sending patches, reporting bugs, asking questions, suggesting useful
advises, nitpicking, chatting on IRC or commenting on my blog (in no particular
order):

    David Kamholz

=head1 LICENSE AND COPYRIGHT

Copyright 2012 jkutej@cpan.org

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

