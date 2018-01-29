# Azure-Create-Well-Named-VMs
Create a well named VNET, Subnet, NSG and Azure VMs with cleanly named NICs and attached disks.

This will create a VM that sorts cleanly in the Azure portal.  You avoid getting a bunch of default names that are not "clean".

![alt tag](https://raw.githubusercontent.com/AdamPaternostro/Azure-Create-Well-Named-VMs/master/CreateCleanVM.png)

## How to use
You can cut and paste this code directly in the Azure Bash Portal prompt, no need to install the Azure 2.0 CLI.
You can modify this script to comment out the VNET creation and just use the VM create part as well.

## Why Azure CLI 2.0
Why this versus an ARM template: In my opinion this is easier to read and debug that a large ARM template.  It is not better at running in parallel.  So, the ARM template is technically better, but this allows you to easily add items and make comments.

## Notes
You should change the ssh password or use a ssh key (perferred).
https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az_vm_create 
