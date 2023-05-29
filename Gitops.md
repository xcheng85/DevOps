# Gitops
process
## Goal
single source of truth
snapshot of state

1. AUDITABLE
2. REPEATABLE
3. version-controlled
4. reliable

declaritive
yaml
json


State drift



## Push-based Gitops
Kubectl apply after a pipeline run


### Pipeline
1. a ioc repo
2. terraform apply




## Pull-based GitOps

Kubernetes operator:
pre-requiste: install in cluster
webhook configuration listen changes in the git repo

1. ArgoCD:
    kubectl apply
2. Flux CD


## Git + Terraform 
CLI workflow
copy the local tf dir to the cloud and run it locally

1. local dev
2. -backend-config=dev.hcl
3. terraform login, azure login, api token to access


Version control workflow 
1. no pipeline
2. no control:
    a. no validation
    b. no testing
    c. no extra step to check security, etc.
3. authorize the terrafrom cloud to access your git repo
4. trigger policy


API-driven workflow:
1. lightops
2. Pipeline as code
    a. github actions
    b. called terraform cli 
