# @summary Provisions machines
#
# Provisions machines for integration testing
#
# @example
#   rook::provision_integration
plan rook::provision_cluster(
  Optional[String] $gcp_image = 'centos-7',
) {
  #provision server machine, set role
  run_task('provision::provision_service', 'localhost',
    action => 'provision', platform => $gcp_image, vars => 'role: controller')
  run_task('provision::provision_service', 'localhost',
    action => 'provision', platform => $gcp_image, vars => 'role: worker1')
  run_task('provision::provision_service', 'localhost',
    action => 'provision', platform => $gcp_image, vars => 'role: worker2')
  run_task('provision::provision_service', 'localhost',
    action => 'provision', platform => 'windows-2012-r2-core', vars => 'role: test')
}
