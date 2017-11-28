# This class installs the Helm repo for rook and the rook chart

class rook::install (
  $env          = $rook::env,
  $path         = $rook::path,
  $rook_channel = $rook::rook_channel,
  $repo_url     = $rook::repo_url,

 ) {

  helm::repo { $rook_channel:
    ensure     => present,
    env        => $env,
    path       => $path,
    repo_name  => $rook_channel,
    url        => $repo_url,
    before     => Helm::Chart['rook']
  }

  helm::chart { 'rook':
    ensure       => present,
    chart        => "rook-${rook_channel}/rook",
    env          => $env,
    path         => $path,
    release_name => 'rook',
  }
}