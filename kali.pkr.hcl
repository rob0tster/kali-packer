packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.3"
      source = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "basic-example" {
  vm_name = "kali"
  cpus = "4"
  memory = "9972"
  iso_checksum = "aeb29db6cf1c049cd593351fd5c289c8e01de7e21771070853597dfc23aada28"
  iso_url = "https://cdimage.kali.org/kali-2022.4/kali-linux-2022.4-installer-amd64.iso"
  ssh_username = "botster"
  ssh_password = "botster"
  ssh_wait_timeout = "60m"
  headless = "false"
  network = "nat"
  shutdown_command = "sudo -S shutdown -P now"
  boot_wait = "5s"
  disk_size = "80000"
  output_directory = "/home/botster/vmware/kali-test"
  http_directory = "http"
  boot_command = [
      "<esc><wait>",
      "install ",
      "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kali.cfg ",
      "debian-installer=en_US auto locale=en_US kbd-chooser/method=us <wait>",
      "netcfg/get_hostname=kali ",
      "netcfg/get_domain=unassigned-domain ",
      "fb=false debconf/frontend=noninteractive ",
      "console-setup/ask_detect=false <wait>",
      "console-keymaps-at/keymap=us ",
      "keyboard-configuration/xkb-keymap=us <wait>",
      "<enter><wait10><wait10><wait10>",
      "<enter><wait>"
    ]
}


build {
  sources = ["sources.vmware-iso.basic-example"]

  # updates system, installs ansible, and installs ansible galaxy roles
  provisioner "shell" {
    inline = ["sudo -S apt update", "sudo apt upgrade -y", "sudo apt autoremove -y", "sudo -S apt-get install -y ansible"]
  }

  # Run ansible
  provisioner "ansible-local" {
    galaxy_file = "kali-ansible/galaxy.yml"
    playbook_file = "kali-ansible/playbook.yml"
    role_paths = ["kali-ansible/ansible_roles"]
    staging_directory = "/tmp"
  }

}