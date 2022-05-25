# @summary
#   This module installs and configures Rook on a Kubernetes cluster.
#
class rook::params {
  $env             = ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf']
  $path            = ['/usr/bin', '/bin']
  $version         = 'v0.7.0'
  $default_storage = true
}
