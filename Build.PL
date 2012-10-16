use strict;
use Module::Build;

my $build = Module::Build->new(
    module_name         => 'Catalyst::Plugin::Authentication::Store::UserXML',
    license             => 'perl',
    requires            => {
        'Catalyst::Plugin::Authentication' => 0,
        'Catalyst::Authentication::User'   => 0,
        'XML::LibXML' => '0',
        'Moose' => '0',
        'Path::Class' => '0',
        'Authen::Passphrase' => '0',
    },
    build_requires => {
        'Test::More'        => 0,
        'File::Temp'        => 0,
        'Path::Class'       => 0.26,
    },
    configure_requires  => { 'Module::Build' => 0 },
    dist_author         => 'Jozef Kutej <jkutej@cpan.org>',
    create_readme       => 1,
    add_to_cleanup      => [ 'Catalyst-Plugin-Authentication-Store-UserXML-*' ],
    meta_merge => {
        resources => {
            repository => 'http://github.com/jozef/Catalyst-Plugin-Authentication-Store-UserXML',
            bugtracker => 'http://github.com/jozef/Catalyst-Plugin-Authentication-Store-UserXML/issues',
        },
        keywords => [ qw/ catalyst store xml folder / ],
    },
);
$build->create_build_script;

