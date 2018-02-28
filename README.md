#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with rook](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Rook is an open source orchestrator for distributed storage systems running in cloud native environments, and provides file, block, and object storage services.

## Setup

To install the rook module, include the `rook` class by adding the following code to the manifest file:

```puppet
include 'rook'
```

## Usage

To customize options, such as the release channel, add the following code to the manifest file:

```puppet
class { 'rook':
  version => 'v0.7.0',
}
```

### Tasks

Included in the rook module is an example task. This creates the rook namespace, and executes the kubectl tasks to configure rook on kubernetes.

```puppet
bolt task run rook::rook_namespace kubeconfig=<path-to-config-file> namespace=<namespace-title> ---nodes <k8s-node-name> --user <user> --password <password> --modulepath <module-path>
```

```puppet
bolt task run rook::rook_create kubeconfig=<path-to-config-file> config_file=<path-to-config-file> ---nodes <k8s-node-name> --user <user> --password <password> --modulepath <module-path>
```

For additional information on how to execute a task, see the [PE](https://puppet.com/docs/pe/2017.3/orchestrator/running_tasks.html) documentation or the [Bolt](https://puppet.com/docs/bolt/latest/bolt.html) documentation.

## Reference

### Classes

#### Public Classes

* [`rook`](#::rook)

#### Private Classes

* [`rook::packages`](#::rook::package). Installs the required Ceph packages.
* [`rook::storage_class`](#::rook::storage_class). Executes configuration tasks for kubernetes.

#### Class: `rook`

Installs and configures rook.

When the `rook` class is decreated, puppet does the following:
 * Downloads and intalls Ceph packages
 * Configures rook on kubernetes

##### Parameters

* `env`: Sets the environment variables for Kubectl to connect to the Kubernetes cluster. Default: `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`
* `path`: Sets the PATH for all exec resources in the module
* `version`: Sets the version of rook to install

## Limitations

This module is compatible only with the `Linux` kernel.

## Development

If you have an issue with this module or would like to request a feature, [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you have problems with this module, [contact Support](https://puppet.com/support-services/customer-support).

### Contributing

If you would like to contribute to this module, please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-rook/blob/master/CONTRIBUTING.md).
