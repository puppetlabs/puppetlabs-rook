[![Build Status](https://travis-ci.com/puppetlabs/puppetlabs-rook.svg?token=MxrBLrbY3Hry1qsacDQC&branch=master)](https://travis-ci.com/puppetlabs/puppetlabs-rook)

# rook

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with rook](#setup)
    * [What rook affects](#what-rook-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with rook](#beginning-with-rook)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Rook provides file, block, and object storage services for your cloud-native environments.

This module uses [Helm](https://helm.sh) to install [Rook](https://rook.io/) for [Kubernetes](https://kubernetes.io/).

## Setup

Before installing Rook, make sure you have Helm running on your Kubernetes cluster. For information about installing Helm, see the [Helm module](https://forge.puppet.com/puppetlabs/helm) and the [Helm documentation](https://docs.helm.sh/).

To install the Rook module, include the `rook` class by adding the following code to the manifest file:

```puppet
include 'rook'
```

## Usage

To customize options, such as the release channel, add the following code to the manifest file:

```puppet
class { 'rook':
  rook_channel => 'rook-stable',
}
```

### Tasks

Included in the Rook module is an example task. This creates the rook namespace, and executes the kubectl tasks to configure rook on kubernetes.

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

#### Private

* [`rook::install`](#::rook::install). Installs the rook helm repository and chart.
* [`rook::package`](#::rook::package). Installs the required Ceph packages.
* [`rook::storage_class`](#::rook::storage_class). Executes additional configuration tasks for kubernetes.

#### Class: `rook`

Installs and configures rook.

When the `rook` class is decreated, puppet does the following:
 * Downloads and intalls Ceph packages
 * Configures the Helm repository and installs the helm chart
 * Configures rook on kubernetes

##### Parameters

* `env`: Sets the environment variables for Helm and Kubectl to connect to the Kubernetes cluster. Default: `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`
* `path`: Sets the PATH for all exec resources in the module
* `rook_channel`: Sets the release channel for the rook packages
* `repo_url`: Sets the upstream URL for the helm repository

## Limitations

This module is compatible only with the `Linux` kernel.

## Development

### Contributing

If you would like to contribute to this module please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-rook/blob/master/CONTRIBUTING.md).
