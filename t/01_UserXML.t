#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use File::Temp qw/tempdir/;
use Path::Class 0.26 'file';

use_ok("Catalyst::Plugin::Authentication::Store::UserXML::Folder");

my $tmp_dir = Path::Class::Dir->new(tempdir( CLEANUP => 1 ));
my $userxml_folder = Catalyst::Plugin::Authentication::Store::UserXML::Folder->new({
    folder => $tmp_dir
});
file($tmp_dir, 'uname01.xml')->spew(user01_xml());
file($tmp_dir, 'uname02.xml')->spew(user02_xml());

can_ok($userxml_folder, "user_supports");
ok( $userxml_folder->user_supports(qw/password self_check/), "user_supports password self_check" );

can_ok($userxml_folder, "find_user");
isa_ok( my $user = $userxml_folder->find_user({username=>"uname01"}), "Catalyst::Plugin::Authentication::Store::UserXML::User");
isa_ok( $user, "Catalyst::Authentication::User");
isa_ok( my $user2 = $userxml_folder->find_user({username=>"uname02"}), "Catalyst::Plugin::Authentication::Store::UserXML::User");

is( $user->username, 'uname01', '$user->id()');

can_ok( $user, "check_password");
ok( $user->check_password( "secretX" ), "password is secretX");
ok( !$user->check_password( "secretx" ), "password is not secretx");

can_ok( $user, "roles");
is_deeply( [$user->roles], [], "user->roles()");
is_deeply( [$user2->roles], [qw(member admin)], "user2->roles()");

can_ok( $userxml_folder, "from_session" );
can_ok( $user, "for_session" );
my $recovered = $userxml_folder->from_session( undef, $user->for_session );
is( $recovered->username, $user->username, "recovery from session works");

done_testing();


sub user01_xml {
    return q{
<user>
    <username>uname01</username>
    <password>{CLEARTEXT}secretX</password>
</user>
};
}
sub user02_xml {
    return q{
<user>
    <username>uname02</username>
    <password>{CLEARTEXT}secret-02</password>
    <roles>
        <role>member</role>
        <role>admin</role>
    </roles>
</user>
};
}
