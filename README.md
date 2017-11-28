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

## Overview

Rook provides File, Block, and Object Storage Services for your Cloud-Native Environments

## Description

This module installs [Rook](https://rook.io/) for [Kubernetes](https://kubernetes.io/). It uses [Helm](https://helm.sh) to install Rook.


## Setup

Before install Rook, ensure you have Helm running on your Kubernetes cluster. See the [Helm module](https://forge.puppet.com/puppetlabs/helm) and the [Helm documentation](https://docs.helm.sh/) for information about installing Helm.

To install the rook module, include the `rook` class:

```puppet
include 'rook'
```

##Usage

To customse options, such as the release channel, add the following code to the manifest file:

```puppet
class { 'rook':
  rook_channel => 'rook-stable',
}
```



If there's more that they should know about, though, this is the place to mention:

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

## Reference

### Classes

#### Public Classes

* ['rook'](#::rook)

#### Private

* ['rook::install'](#::rook::install). Installs the rook helm repository and chart.
* ['rook::package'](#::rook::package). Installs the required Ceph packages.
* ['rook::storage_class'](#::rook::storage_class). Executes additional configuration tasks for kubernetes.

#### Class: `rook`

Installs and configures rook.

When the `rook` class is decreated, puppet does the following:
 * Downloads and intalls Ceph packages
 * Configures the Helm repository and install the helm chart
 * Configures rook on kubernetes

##### Parameters

* `env`: Sets the environment variables for Helm and Kubectl connect to the Kubernetes cluster. Default: `[ 'HOME=/root', 'KUBECONFIG=/root/admin.conf']`
* `path`: Sets the PATH for all exec resources in the module
* `rook_channel`: Sets the release channel for the rook packages
* `repo_url`: Sets the upstream URL for the helm repository




## Limitations

This module is compatible only with the `Linux` kernel.

## Development

### Contributing

If you would like to contribute to this module please follow the rules in the [CONTRIBUTING.md](https://github.com/puppetlabs/puppetlabs-rook/blob/master/CONTRIBUTING.md).
