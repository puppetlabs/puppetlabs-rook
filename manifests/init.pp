# @summary
#   This module installs and configures Rook on a Kubernetes cluster.
#
# @param env
#    Specifies the environment variables for Kubectl to connect to the Kubernetes cluster.
#    Defaults to `['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf']`.
# 
# @param path
#    Specifies the PATH for all exec resources in the module.
#    Defaults to `['/usr/bin', '/bin']`.
#
# @param version
#    Specifies the version of rook to install.
#    Defaults to `'v0.7.0'`.
#
# @param default_storage
#    Specifies whether to set the rook-block as the default storage class for the cluster
#    Defaults to `true`
#
class rook (
  Array $env               = $rook::params::env,
  Array $path              = $rook::params::path,
  String $version          = $rook::params::version,
  Boolean $default_storage = $rook::params::default_storage,
) inherits rook::params {
  include rook::packages
  include rook::storage_class
  contain rook::packages
  contain rook::storage_class

  Class['rook::packages']
  -> Class['rook::storage_class']
}
