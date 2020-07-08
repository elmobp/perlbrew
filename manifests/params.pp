# == Class: perlbrew::params
#
# This class includes the default parameters for the Perlbrew class.
#
# === Parameters
#
# Document parameters here.
#
# [*perlbrew_root*]
#   Specify the root of your perlbew installation. Defaults to '/opt/perl5'.
#
class perlbrew::params {
      $perlbrew_root      = '/opt/perl5'
      $perlbrew_init_file = '/etc/profile.d/perlbrew.sh'
}
