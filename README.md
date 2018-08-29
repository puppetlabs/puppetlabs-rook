#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with rook](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
   * [Tasks](#tasks)
   * [Validating and unit testing the module](#validating-and-unit-testing-the-module)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
   * [Classes](#classes)
   * [Parameters](#parameters)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

[Rook](https://github.com/rook/rook) is an open source orchestrator providing file, block, and object storage services for distributed storage systems running in cloud-native environments.

This module installs and configures Rook on Kubernetes.

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

*Note:* To run static validations and unit tests against this module using the [`pdk validate`](https://puppet.com/docs/pdk/1.x/pdk_testing.html#concept-3313) and [`pdk test unit`](https://puppet.com/docs/pdk/1.x/pdk_testing.html#concept-3975) commands, you must have Puppet 5 or higher installed. In the following examples, we have specified Puppet 5.3.6.

To validate the metadata.json file, run the following command:

```
pdk validate metadata --puppet-version='5.3.6'
```

To validate the Puppet code and syntax, run the following command:

```
pdk validate puppet --puppet-version='5.3.6'
```

To unit test the module, run the following command:

```
pdk test unit --puppet-version='5.3.6'
```

## Reference

### Classes

#### Public Classes

* `rook`: Installs and configures rook.
* `rook::params`

#### Private Classes

* `rook::packages`: Installs the Ceph packages.
* `rook::storage_class`: Installs and configures the Rook storage class for block level storage.

### Parameters

#### `env`

Sets the environment variables for Kubectl to connect to the Kubernetes cluster.

Defaults to `['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf']`.

#### `path`

Sets the PATH for all exec resources in the module.

Defaults to `['/usr/bin', '/bin']`.

#### `version`

Sets the version of rook to install.

Defaults to `'v0.7.0'`.

## Limitations

This module is compatible only with the `Linux` kernel.

## Development

If you have an issue with this module or would like to request a feature, [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you have problems with this module, [contact Support](https://puppet.com/support-services/customer-support).

### Contributing

If you would like to add to this module, please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-rook/blob/master/CONTRIBUTING.md).
