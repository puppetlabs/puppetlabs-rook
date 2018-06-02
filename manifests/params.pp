# == Class: rook::params
class rook::params {

  $env          = ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf']
  $path         = ['/usr/bin', '/bin']
  $version      = 'v0.7.0'
}
