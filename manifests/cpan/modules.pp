# == Class: perlbrew::cpan::install
#
# run cpan command to install modules using a cpanfile.
#
# === Parameters
#
# [*options*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Examples
#
#  class { perlbrew::cpan::install
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
class perlbrew::cpan::modules (

  $cpan_modules  = [],
  $cpanfile_dir  = '/tmp',
  $options       = [],
) {

  include perlbrew::perl

  $default_options = [
    '--installdeps',
  ]

  $merged_options = concat($default_options, $options)
  $install_opts = join($merged_options, ' ')
  $cpan_modules.each |$cpan_module| {
    $cpan_deps_command = "${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/bin/cpanm ${install_opts} ${cpan_module}"
    $file_path = regsubst($cpan_module, '::', '/', 'G')
    exec {"install_perl_module_deps_${cpan_module}":
      command     => $cpan_deps_command,
      timeout     => 0,
      creates     => "${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/lib/${perlbrew::perl::version}/${file_path}",
      environment => [
        "PERLBREW_ROOT=${perlbrew::perlbrew_root}",
        'PERLBREW_HOME=/tmp/.perlbrew',
        "PERLBREW_PERL=perl-${perlbrew::perl::version}",
        "PERLBREW_PATH=${perlbrew::perlbrew_root}/bin:${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/bin",
        "PERLBREW_MANPATH=${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/man",
        'HOME=/opt',
      ],
      path        => [
        "${perlbrew::perlbrew_root}/bin",
        '/usr/bin',
        '/usr/sbin',
        '/bin',
        '/sbin'
      ],
    }
    $cpan_command = "${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/bin/cpanm ${cpan_module}"
    exec {"install_perl_module_${cpan_module}":
      command     => $cpan_command
      timeout     => 0,
      creates     => "${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/lib/${perlbrew::perl::version}/${file_path}",
      environment => [
        "PERLBREW_ROOT=${perlbrew::perlbrew_root}",
        'PERLBREW_HOME=/tmp/.perlbrew',
        "PERLBREW_PERL=perl-${perlbrew::perl::version}",
        "PERLBREW_PATH=${perlbrew::perlbrew_root}/bin:${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/bin",
        "PERLBREW_MANPATH=${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/man",
        'HOME=/opt',
      ],
      path        => [
        "${perlbrew::perlbrew_root}/bin",
        '/usr/bin',
        '/usr/sbin',
        '/bin',
        '/sbin'
      ],
      require     => Exec["install_perl_module_deps_${cpan_module}"]
    }
  }

}
