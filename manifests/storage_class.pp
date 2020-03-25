# @summary
# Installs and configures the Rook storage class for block level
#
# @api private
class rook::storage_class (
  Array $env               = $rook::env,
  Array $path              = $rook::path,
  String $version          = $rook::version,
  Boolean $default_storage = $rook::default_storage,

) {

  $rook_files = ['rook-operator.yaml','rook-cluster.yaml', 'rook-storage.yaml']

  Exec {
    path        => $path,
    environment => $env,
    logoutput   => true,
    tries       => 10,
    try_sleep   => 30,
  }

  $rook_files.each | String $file | {
      file { "/tmp/${file}":
        ensure  => present,
        content => template("rook/${file}.erb"),
        }
    }

  exec { 'Create rook namespace':
    command => 'kubectl create namespace rook',
    unless  => 'kubectl get namespace | grep rook',
    before  => Exec['Create rook operator'],

  }

  exec { 'Create rook operator':
    command     => 'kubectl create -f rook-operator.yaml',
    cwd         => '/tmp',
    subscribe   => File['/tmp/rook-operator.yaml'],
    refreshonly => true,
    before      => Exec['Create rook cluster'],
    require     => File['/tmp/rook-operator.yaml'],
  }

  exec {'Checking for the Rook operator to be ready':
    command   => 'kubectl get pods -n rook-system| grep rook-operator | grep -w Running',
    logoutput => true,
    unless    => 'kubectl get pods -n rook-system| grep rook-operator | grep -w Running',
    require   => Exec['Create rook operator'],
  }

  exec {'Checking for the Rook agent to be ready':
    command   => 'kubectl get pods -n rook-system| grep rook-agent | grep -w Running',
    logoutput => true,
    unless    => 'kubectl get pods -n rook-system| grep rook-agent | grep -w Running',
    require   => Exec['Checking for the Rook operator to be ready'],
  }

  exec { 'Create rook cluster':
    command     => 'kubectl create -f rook-cluster.yaml',
    cwd         => '/tmp',
    subscribe   => File['/tmp/rook-cluster.yaml'],
    refreshonly => true,
    before      => Exec['Create storage class'],
    require     => File['/tmp/rook-cluster.yaml'],
  }

  exec {'Checking for the Rook api to be ready':
    command   => 'kubectl get pods -n rook | grep rook-api | grep -w Running',
    logoutput => true,
    unless    => 'kubectl get pods -n rook | grep rook-api | grep -w Running',
    require   => Exec['Create rook cluster'],
  }

  exec { 'Create storage class':
    command     => 'kubectl create -f rook-storage.yaml',
    cwd         => '/tmp',
    subscribe   => File['/tmp/rook-storage.yaml'],
    refreshonly => true,
    require     => File['/tmp/rook-storage.yaml'],
  }
  if $default_storage {
    exec { 'Set default storage class':
      command => 'kubectl patch storageclass rook-block -p \'{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}\'',
      unless  => 'kubectl get storageclass rook-block | grep "rook-block (default)"',
      require => Exec['Create storage class'],
    }
  }
}
