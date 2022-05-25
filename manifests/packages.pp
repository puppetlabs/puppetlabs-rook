# @summary
# Installs the Ceph packages.
#
# @api private
class rook::packages {
  $rook_packages = $facts['os']['name'] ? {
    /(?i:Ubuntu|Debian)/ => ['ceph-common', 'ceph-fs-common'],
    /(?i:RedHat|CentOS)/ => ['ceph-common', 'ceph-deploy'],
    default              => ['ceph-common', 'ceph-fs-common'],
  }

  case $facts['os']['name'] {
    'CentOS': {
      if ! defined(Class['epel']) {
        include epel
      }
    }
    default: {}
  }

  package { $rook_packages:
    ensure => present,
  }
}
