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
Version: 1.1
DateCreated: 2015-07-21
DateUpdated: 2015-08-10

.LINK
http://thatclyde.com
http://resnet.missouristate.edu

.EXAMPLE   
.\Get-Start-CheckpointManagement.ps1

Description:
Will create a checkpoint for each virtual machine running on your hyper-V server. 
If there are any checkpoints that the script created previously that are $DaysKept old or older, they will be deleted.

.NOTES:
This script only kind of addresses the 1599/1600 bug, where checkpoints will report that they were initially created centuries ago. If it's a checkpoint that purports to be that old, this script will ignore it.

#>
#define local variables
$VMs = '*'
$DaysKept = 29

#Finds Selected VMs (All by default), creates checkpoints for those VMs with the name "Auto Checkpoint" followed by the date (in a sortable format).
Get-VM $VMs | Checkpoint-VM -SnapshotName "Auto Checkpoint $((Get-Date -Format s))"
#Finds all checkpoints from the selected VMs with the name that begins "Auto Checkpoint", and, if they're older than the date in the $DaysKept variable, it deletes them. There is an additional "greater than 100 years" clause to catch the 1600 year bug.
Get-VMSnapshot -VMName $VMs | Where-Object {$_.Name -Match "Auto Checkpoint*" -and $_.CreationTime -lt (Get-Date).AddDays(-$DaysKept) -and $_.CreationTime -gt (Get-Date).AddYears(-100)} | Remove-VMSnapshot

