# == Class: perlbrew::install
#
# This class installs Perlbrew and is meant to be called from perlbrew
#
class perlbrew::install {
  include archive

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
  ~> archive{'/tmp/perlbrew-install':
    source => 'https://raw.githubusercontent.com/gugod/App-perlbrew/master/perlbrew-install'
  }
  ~> file{'/tmp/perlbrew-install':
    ensure => file,
    mode   => '0755'
  }
  ~> exec {'install_perlbrew':
    environment => [ "PERLBREW_ROOT=${perlbrew::perlbrew_root}", 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', 'HOME=/tmp'],
    command     => '/tmp/perlbrew-install', 
    creates     => "${perlbrew::perlbrew_root}/bin/perlbrew",
    require     => Package['curl'],
  }

}
