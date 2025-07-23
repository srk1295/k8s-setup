k8s master and worker node script have been scripted in IaC Terraform.
And we need to install vms for k8s nodes as 1 master and 2 worker use this terraform script.
### Cmds ###
####### terraform init 
terraform validate .
terraform plan .
terraform apply .
terraform destroy . or terraform destroy --target=<aws_instance.ec2-1>[1]    #terraform destroy --target=<resource_address>
terraform show
terraform state list # if pending here you can see and choose as presented here.
### need to setup an k8s in a vm's as created now ###


# git cmds #
git merge	Combine entire branches
git rebase	Reapply commits linearly
git cherry-pick	Apply specific commits only
#
