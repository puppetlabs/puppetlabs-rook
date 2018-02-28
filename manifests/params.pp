# == Class: rook::params
class rook::params {

  $env          = ['HOME=/root', 'KUBECONFIG=/root/admin.conf']
  $path         = ['/usr/bin', '/bin']
  $version      = 'v0.7.0'
}
