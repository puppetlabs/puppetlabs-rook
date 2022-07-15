#### Table of Contents

- [Description](#Description)
* [Support](#support)
- [Setup](#Setup)
- [Usage](#Usage)
  - [Tasks](#Tasks)
  - [Validating and unit testing the module](#Validating-and-unit-testing-the-module)
- [Reference](#Reference)
- [Limitations](#Limitations)
- [Development](#Development)
  - [Contributing](#Contributing)

## Description

[Rook](https://github.com/rook/rook) is an open source orchestrator providing file, block, and object storage services for distributed storage systems running in cloud-native environments.

This module installs and configures Rook on a Kubernetes cluster.

## Support

This module is not supported or maintained by Puppet and does not qualify for Puppet Support plans.
It's provided without guarantee or warranty and you can use it at your own risk.
All bugfixes, updates, and new feature development will come from community contributions.
[tier:community]

## Setup

To install the rook module, add the `rook` class to the manifest file:

```puppet
include 'rook'
```

When the `rook` class is declared, Puppet does the following:
* Downloads and installs the Ceph packages.
* Configures Rook on Kubernetes.

## Usage

To customize options, such as the release channel, add the following code to the manifest file:

```puppet
class { 'rook':
  version => 'v0.7.0',
}
```

### Tasks

Included in the rook module is an example task that creates the rook namespace, and executes the kubectl tasks to configure rook on kubernetes.

```puppet
bolt task run rook::rook_namespace kubeconfig=<path-to-config-file> namespace=<namespace-title> ---nodes <k8s-node-name> --user <user> --password <password> --modulepath <module-path>
```

```puppet
bolt task run rook::rook_create kubeconfig=<path-to-config-file> config_file=<path-to-config-file> ---nodes <k8s-node-name> --user <user> --password <password> --modulepath <module-path>
```

For additional information on how to execute a task, see the [PE](https://puppet.com/docs/pe/2018.1/running_tasks.html) documentation or the [Bolt](https://puppet.com/docs/bolt/latest/writing_tasks_and_plans.html) documentation.

### Validating and unit testing the module

This module is compliant with the Puppet Development Kit [(PDK)](https://puppet.com/docs/pdk/1.x/pdk_install.html), which provides tools to help run unit tests on the module and validate the modules' metadata, syntax, and style.

*Note:* To run static validations and unit tests against this module using the [`pdk validate`](https://puppet.com/docs/pdk/1.x/pdk_testing.html#concept-3313) and [`pdk test unit`](https://puppet.com/docs/pdk/1.x/pdk_testing.html#concept-3975) commands, you must be using Puppet 5 or higher. In the following examples, we have specified Puppet 5.5.3.

To validate the metadata.json file, run the following command:

```
pdk validate metadata --puppet-version='5.5.3'
```

To validate the Puppet code and syntax, run the following command:

```
pdk validate puppet --puppet-version='5.5.3'
```

To unit test the module, run the following command:

```
pdk test unit --puppet-version='5.5.3'
```

## Reference

[REFERENCE.md](https://github.com/puppetlabs/puppetlabs-rook/blob/main/REFERENCE.md).

## Limitations

This module is compatible only with the `Linux` kernel and supports:

* Puppet 4 or higher.
* Kubernetes [1.10.x](https://github.com/kubernetes/kubernetes/blob/main/CHANGELOG.md#v160) or higher.
* Ruby 2.3.0 or higher.

## Development

If you have an issue with this module or would like to request a feature, [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you have problems with this module, [contact Support](https://puppet.com/support-services/customer-support).

### Contributing

If you would like to add to this module, please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-rook/blob/main/CONTRIBUTING.md).

To run the acceptance tests you can use Puppet Litmus with the Vagrant provider by using the following commands:

    bundle exec rake 'litmus:provision_list[all_supported]'
    bundle exec rake 'litmus:install_agent[puppet5]'
    bundle exec rake 'litmus:install_module'
    bundle exec rake 'litmus:acceptance:parallel'

As currently Litmus does not allow memory size and cpu size parameters for the Vagrant provisioner task we recommend to manually update the Vagrantfile used by the provisioner and add at least the following specifications for the puppetlabs-kubernetes module acceptance tests:

**Update Vagrantfile in the file: spec/fixtures/modules/provision/tasks/vagrant.rb**
    vf = <<-VF 
    Vagrant.configure(\"2\") do |config|
    config.vm.box = '#{platform}'
    config.vm.boot_timeout = 600
    config.ssh.insert_key = false
    config.vm.hostname = "testkube"
    config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
    end
    #{network}
    #{synced_folder}
    end
    VF
