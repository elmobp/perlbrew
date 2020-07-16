# == Class: perlbrew::install
#
# This class installs Perlbrew and is meant to be called from perlbrew
#
class perlbrew::install {

  if !defined(Package['curl']) {
    package {'curl':
      ensure => present,
    }
  }

  file {$perlbrew::perlbrew_root:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  exec {'install_perlbrew':
    environment => [ 'PERLBREW_ROOT=/opt/perl5', 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'],
    command     => '/usr/bin/curl -L https://gist.githubusercontent.com/elmobp/1fea91fd2afd044c59b0e105dbfc1fea/raw/ee720518233b5e82cf037130f7933d9737dd6b95/installer.sh | /bin/bash',
    creates     => "${perlbrew::perlbrew_root}/bin/perlbrew",
    require     => Package['curl'],
  }

}
