# This class installs packages that rook needs

class rook::packages {

  $rook_packages = $::operatingsystem ? {
    /(?i:Ubuntu|Debian)/ => [ 'ceph-common', 'ceph-fs-common'],
    /(?i:RedHat|CentOS)/ => [ 'ceph-common', 'ceph-deploy'],
    default              => [ 'ceph-common', 'ceph-fs-common'],
  }

  package { $rook_packages:
    ensure => present,
  }
}
