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
    concat {"${cpanfile_dir}/${cpan_module}":
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

    $cpan_command = "${perlbrew::perlbrew_root}/perls/perl-${perlbrew::perl::version}/bin/cpanm ${install_opts} ${cpan_module}"

    exec {"install_perl_module_${cpan_module}":
      command     => $cpan_command,
      subscribe   => Concat["${cpanfile_dir}/${cpan_module}"],
      refreshonly => true,
      timeout     => 0,
    }
  }

}
