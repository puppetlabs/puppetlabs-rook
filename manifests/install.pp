# This class installs the Helm repo for rook and the rook chart

class rook::install {

  $env = [ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']
  $path = ['/usr/bin', '/bin']
  $helm_files = ['rook-cluster.yaml', 'rook-storage.yaml']

  helm::repo { 'rook-alpha':
    ensure    => present,
    env       => $env,
    path      => $path,
    repo_name => 'rook-alpha',
    url       => 'http://charts.rook.io/alpha',
    before    => Helm::Chart['rook']
  }

  helm::chart { 'rook':
    ensure       => present,
    chart        => 'rook-alpha/rook',
    env          => $env,
    path         => $path,
    release_name => 'rook',
  }



  $helm_files.each | String $file | {
      file { "/tmp/${file}":
        ensure  => present,
        content => template("rook/${file}.erb"),
        }
    }
}
