# Kali Packer

## Table of Contents

- [Project Overview](#project-overview)
- [Packer VM Creation Steps](#packer-vm-creation-steps)
  - [Provisioning the VM](#provisioning-the-vm)
  - [Preseeding](#preseeding)
- [Post Install Commands](#post-install-commands)
- [Ansible](#ansible)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Contributing](#contributing)
- [Usage](#usage)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Project Overview

I'm a person who re-configs his Virtual Machines a lot. Given how many tools and configurations I like to install, this can take me upwards of 2 hours assuming I even remember all my favorite tools in the first place. So, instead of repeating this every time, I put together a [packer](https://www.packer.io/) configuration to set it up for me. Using this, all I have to do is run the packer file and it will take care of everything from iso download to fresh install

My config utilizes vmware as the virtualization product, but it can easily be converted to virtualbox, proxmox, or other hypervizors if needed. 

## Packer VM Creation Steps

### Provisioning the VM
The name, specs, networking information, etc. can be found in kali.pkr.hcl. My configuration is set up for vmware, but it can be easily converted to virtualbox, proxmox, or other machine images like an EC2s.
- Packer supports a **lot** of platforms, you can find a list [here](https://developer.hashicorp.com/packer/integrations)
- note that I have not experimented with platforms outside of vmware, virtualbox, and proxmox. Mileage may vary

### Preseeding 

I use a [pre-seed file](https://wiki.debian.org/AutomatedInstallation) to pre-answer all the questions you're asked in a kali install. This configures things like the timezone, new user name, and initial password. These can be modified from inside kali.cfg. - Packer automatically spins up an http server on the VM's local network to pull down the preseed file.

## Post Install Commands

Once Installation is complete, Packer uses the credentials defined in kali.pkr.hcl to run commands on the new system 
- ssh credentials must correspond to the username and password supplied in the preseed file
- unless changed, the preseed & ssh creds are `botster:botster`

I run `sudo apt update && sudo apt upgrade && sudo apt autoremove` before installing ansible.
- the ansible installation is needed so we can use the ansible playbooks described in the next step

## Ansible

From here control is passed off to [kali-ansible](https://github.com/rob0tster/kali-ansible). For more detail check out the README on that tool, but high level, kali-ansible:
- installs some extra packages
- copies over config files for tools like .rc files (not included)
- installs burp suite and vscode via ansible galaxy packages

Once finished, packer packs up the image, ready for use. The image will be output as specified with the `output_directory` variable in `kali.pkr.hcl`

## Getting Started

### Prerequisites
To install packer, install per [this guide](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)

You will also need the hypervizor solution for packer to configure your machine in

### Installation

1. Clone this repo with: `git clone --recursive git@github.com:rob0tster/kali-packer.git`
2. Add any ansible playbooks you might want into **kali-ansible**

## Contributing

I welcome any contributions! If you'd like to contribute to the project, please follow these guidelines:

1. Fork the repository
2. Create a new branch for your feature or bug fix
3. Make your changes
4. Submit a pull request

We appreciate your help in making this project better!

## Usage
1. cd into the kali-packer folder: `cd kali-packer`
2. initialize packer plugins: `packer init .`
3. kick it off: `packer build .`
4. watch the building happen

## License 
This project is licensed under the [MIT License](LICENSE.md) - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgements
- Huge props to [Packer](https://www.packer.io/). I really enjoy this tool and it's saved me a **lot** of time
- [Ansible](https://www.ansible.com/) also was invaluble in automating the install process



