<#
.SYNOPSIS   
Script to create a checkpoint for all the VMs running on your Hypervisor and delete all checkpoints previously created by this script that are more than 4 weeks old.    

.DESCRIPTION
Desigened to work as a scheduled task, this script creates checkpoints for all the virtual machines on your hyper-v server.
It also deletes any previously automatically generated checkpoints that are more than 4 weeks old, so you will get a rolling 4 weeks of checkpoints. 
It should not delete any manually created checkpoints (unless you rename them "Auto Checkpoint*"

.NOTES   
Name: VMCheckpointMaker$Deleter.ps1
Author: Clyde Miller / ResNet @ Missouri State
Version: 1.0
DateCreated: 2015-07-21
DateUpdated: 

.LINK
http://thatclyde.com
http://resnet.missouristate.edu

.EXAMPLE   
.\Get-Set-ADAccountasLocalAdministrator.ps1

Description:
Will create a checkpoint for each virtual machine running on your hyper-V server. 
If there are any checkpoints that the script created previously that are 29 days old or older, they will be deleted.

.NOTES:
If you want to alter how long the backups are kept, change the number in this section of line 30: "(Get-Date).AddDays(-XX)"

#>
Get-VM | Checkpoint-VM -SnapshotName "Auto Checkpoint $((Get-Date).toshortdatestring())"
Get-VMSnapshot -VMName * | Where-Object {$_.Name -Match "Auto Checkpoint*" -and $_.CreationTime -lt (Get-Date).AddDays(-29) } | Remove-VMSnapshot
