# Terraform

## Infrastructure in company
1. Database
2. Server
3. Network
4. Virtualization
5. Security

cloud and on-premise

vmware datacenter on-premise

empheral environment for budget 

bash script


```shell
# imperitive

#!/bin/bash

set -e 

aws ec2 create-vpc 

```

## Terraform

1. provider

2. authentication for provider

3. resource

4. data source: manage previous mannually created resource to this terraform

5. local var

6. public var

7. output

8. provisioner: run scripts to remote vm
   local provisioner: ansible to config

9. count and map for multiple same instance

10. store tfstate remotely

11. format tf with terraform fmt

12. terraform import for existing infrastructure

13. terraform state remove

14. terraform modules: host in git use git tag , input output, variable, default values



## Dev
Terraform vs code plugin

## State
terraform.state

## Provider
kubernetes
azure,
aws,

## CLI

terrafrom apply
update state
deployed the resource


## Questions
1. How to delete partial resource
   comment out what you want to delete
   and terraform plan/apply



