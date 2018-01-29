#!/bin/bash

#############################
# Global items
#############################
azureregion="eastus2"
resouceGroup="AdamGroup"
tags="CostCenter=1000 Environemnt=Dev"


#############################
# Create a resource group
#############################
az group create \
--name $resouceGroup \
--location $azureregion \
--tags $tags


#############################
# Create VNET / Subnet / NSGs
#############################
vnetName="AdamVNET"
vnetSubnetName="AdamSubject"
nsgName="AdamNSG"

az network vnet create \
--name $vnetName \
--resource-group $resouceGroup \
--address-prefix 10.0.4.0/24 \
--subnet-name $vnetSubnetName \
--subnet-prefix 10.0.4.0/24 \
--tags $tags

az network nsg create \
--resource-group $resouceGroup \
--name $nsgName \
--tags $tags

az network nsg rule create \
--resource-group $resouceGroup \
--nsg-name $nsgName  \
--name ssh-rule \
--access Allow \
--protocol Tcp \
--direction Inbound \
--priority 1000 \
--source-address-prefix "*" \
--source-port-range "*" \
--destination-address-prefix "*" \
--destination-port-range 22 

az network vnet subnet update \
--vnet-name $vnetName \
--name $vnetSubnetName \
--resource-group $resouceGroup \
--network-security-group $nsgName 


#############################
# Create Availability Set for the VMs (you will need to do one per application tier)
#############################
availabilitySetName="AdamAvailSet"

az vm availability-set create \
--name $availabilitySetName \
--resource-group $resouceGroup \
--platform-fault-domain-count 2 \
--platform-update-domain-count 2 \
--tags $tags


#############################
# VM #1: Create a basic VM with defaults (30GB OS SSD disk)
#############################
availabilitySetName="AdamAvailSet"
vmName="AdamWebServer01"
vmsize="Standard_DS5_v2"
vmImageOS="UbuntuLTS"
vmNic="$vmName-nic"
osDiskName="$vmName-os-disk"

az network nic create \
--resource-group $resouceGroup  \
--vnet-name $vnetName \
--subnet $vnetSubnetName \
--name $vmNic 
# Tags not working --tags $tags

# When specifying an existing NIC, do not specify NSG, public IP, ASGs, VNet or subnet.
az vm create \
--name $vmName \
--resource-group $resouceGroup  \
--availability-set $availabilitySetName \
--image $vmImageOS \
--size $vmsize \
--admin-username speedtestuser \
--admin-password MySecer123Pass \
--nics $vmNic  \
--os-disk-name $osDiskName \
--tags $tags


#############################
# VM #2: Create a basic VM with defaults
# This will create a 30GB SSD disk by default
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/premium-storage
#############################
availabilitySetName="AdamAvailSet"
vmName="AdamWebServer02"
vmsize="Standard_DS5_v2"
vmImageOS="UbuntuLTS"
vmNic="$vmName-nic"
osDiskName="$vmName-os-disk"
osDiskSize="512"
dataDisk1="$vmName-disk-01"
dataDisk1Size="512"
dataDisk1Sku="Premium_LRS"
dataDisk2="$vmName-disk-02"
dataDisk2Size="512"
dataDisk2Sku="Premium_LRS"
dataDisks="$dataDisk1 $dataDisk2"

az network nic create \
--resource-group $resouceGroup  \
--vnet-name $vnetName \
--subnet $vnetSubnetName \
--name $vmNic 
# Tags not working --tags $tags

az disk create \
--resource-group $resouceGroup  \
--name $dataDisk1 \
--size-gb $dataDisk1Size \
--sku $dataDisk1Sku \
--tags $tags

az disk create \
--resource-group $resouceGroup  \
--name $dataDisk2 \
--size-gb $dataDisk2Size \
--sku $dataDisk2Sku \
--tags $tags

az vm create \
--name $vmName \
--resource-group $resouceGroup  \
--availability-set $availabilitySetName \
--image $vmImageOS \
--size $vmsize \
--admin-username speedtestuser \
--admin-password MySecer123Pass \
--nics $vmNic  \
--os-disk-name $osDiskName \
--os-disk-size-gb $osDiskSize \
--attach-data-disks $dataDisks \
--tags $tags
