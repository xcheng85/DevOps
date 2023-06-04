# Experiment with ArgoCD + GitOps

## Install Minikube

brew install minikube
minikube version
1.30.1

## container driver
minikube can be deployed as a VM, a container, or bare-metal.

Docker - VM + Container (preferred)
virtualbox
podman
hyperkit

docker push taviamcboa/devops:tagname

## Mult-node minikube
```shell
# node run container
minikube start --nodes 3 -p devops
# node run vm
minikube start --nodes 3 --driver=virtualbox
minikube start --nodes 3 -p devops --kubernetes-version=v1.26.3 --driver=docker
kubectl get nodes
minikube status -p devops

# clean 
--alsologtostderr -v=4
$ minikube delete --all
$ rm -rf ~/.minikube
$ minikube start --force-systemd=true
minikube delete --all --purge
```

Using Docker Desktop driver with root privileges
Kubernetes v1.26.3 preload
Enabled addons: storage-provisioner, default-storageclass

To be able to provision or claim volumes in multi-node clusters, you could use CSI Hostpath Driver addon.

minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver

## Install Helm

## Install Terraform
```shell
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew update
brew upgrade hashicorp/tap/terraform
terraform -install-autocomplete
```

## Install Argocd
```shell
brew install helm
#v3.12.0
helm version
#https://github.com/argoproj/argo-helm
helm repo add argo https://argoproj.github.io/argo-helm
# after helm add new repo, run
helm repo update
helm search repo argocd
# argo/argocd-image-updater
# argo/argocd-notifications
# latest chart version 3.35.4
helm show values argo/argo-cd --version 3.35.4 > argocd-defaults.yaml

#Option1: helm install

#Option2: terraform install helm / argocd 
# helm provider
# https://registry.terraform.io/providers/hashicorp/helm/latest/docs
# add terraform vs code ext
cd terraform
# .terraform folder
terraform init 
brew install tree
terraform apply -auto-approve
# check helm chart status
helm list --pending -A
helm list -A
kubectl get pods -n argocd
# check admin password for argocd
kubectl get secrets -n argocd
kubectl get secrets argocd-initial-admin-secret -n argocd -o yaml
echo "NEM3VW5sWGdtbVBDYUE5cQ==" | base64 -d
# port-forwarding argocd service
kubectl port-forward svc/argocd-server -n argocd 8081:80
# localhost:8081
username: admin
```

## GitOps Repo
Generating a new SSH key and adding it to the ssh-agent
```shell
$ ssh-keygen -t ed25519 -C "shane85cheng@gmail.com"
passpharase

cat ~/.ssh/id_ed25519

touch ~/.ssh/config
code ~/.ssh/config

Host github.com
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519

ssh-add --apple-use-keychain ~/.ssh/id_ed25519
# public key
cat ~/.ssh/id_ed25519.pub

git clone git@github.com:xcheng85/gitops-test.git
# for private repo
git clone git@github.com:xcheng85/gitops-test-private.git
```
### generate ssh for argocd server
```shell
# difference is in the argocd application
# repo url: https vs git
# authenticate with private git repo
# 1. pat
# 2. github api
# 3. ssh key (for cicd, preferred)
# -f to avoid overwrite
ssh-keygen -t ed25519 -C "argocd@xcheng85.com" -f ~/.ssh/argocd_ed25519
# enter passphrase to be empty
# Your identification has been saved in /Users/xcheng4/.ssh/argocd_ed25519
# Your public key has been saved in /Users/xcheng4/.ssh/argocd_ed25519.pub
cat ~/.ssh/argocd_ed25519.pub
# Deploy ssh keys in githubs
# settings -> deploy keys -> add keys -> r/w access
```

### Create k8s secret for git private sshkey for argocd server
refer to [here](./private-gitops/git-repo-secret.yaml) 

official argocd document [here](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repository-credentials)


1. argocd.argoproj.io/secret-type: repository
    a.sshkey

2. argocd.argoproj.io/secret-type: repo-creds
    a. username password

3. argocd.argoproj.io/secret-type: cluster (GKE)

```shell
kubectl apply -f ./git
```
## dockerhub

```shell
docker login --username taviamcboa
docker pull nginx:1.25.0
docker images
docker tag nginx:1.25.0 taviamcboa/devops/nginx:v0.1.0
docker push taviamcboa/devops/nginx:v0.1.0

# for private dockerhub repo
docker tag nginx:1.25.0 taviamcboa/private-repo:nginx_v0.1.0
docker push taviamcboa/private-repo:nginx_v0.1.0
```

## private dockerhub repo
1. AccessToken for image pull secret
   
   account settings->Security->Access Token

   start with dckr_pat_*

2. Create k8s secret or mounted through vault

   refer to [here](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) 

   a. same namespace of your argocd app
   b. Create a Secret by providing credentials on the command line
   ```shell
   kubectl create secret docker-registry dockerconfigjson -n $ARGOCD_APP_NS --docker-server=https://index.docker.io/v1/ --docker-username=taviamcboa --docker-password=dckr_pat_OopIhgOl1nP-scj2Cn204Citb-k --docker-email=chengxiao1985@gmail.com
   ```


## app of apps pattern
argocd application and kubernetes deployment living in the same git repo

one argocd application manages all the kubernetes deployment (multiple services)

refer to [here](./evd/application.yaml), which pointed to the apps, which then point to git-helm chart


## finalizer

## GitOps with Helm Chart
Helm repo vs git-hosted Helm charts.

our project: git-hosted helm charts

metric-server chart: Helm repo

hpa
kubectl top

```shell
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm upgrade --install metrics-server metrics-server/metrics-server

helm search repo metrics-server

# bitnami/metrics-server          6.4.1           0.6.3           Metrics Server aggregates resource usage data, ...
# metrics-server/metrics-server   3.10.0          0.6.3           Metrics Server is a scalable, efficient source ...

# save default yaml
helm show values metrics-server/metrics-server --version 3.10.0 > metrics-server-defaults.yaml

# create application yaml
# for all the options
refer to [here](https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/application.yaml)

# argocd logic project
https://argo-cd.readthedocs.io/en/stable/user-guide/projects/
use default if not created project before

# metrics allow the kubectl top
kubectl top pods -n kube-system
kubectl top nodes
```

## CI with argocd

update image tag in gitops https://github.com/xcheng85/gitops-test

## CD with argocd image updater
poll dockerhub registry

two options:
1. direct update argocd server
2. git write back (preferrable)
    a. a new commit

### install image updater
use terraform

```shell

helm search repo argocd

helm show values argo/argo/argocd-image-updater --version 0.9.1 > argocd-image-update-defaults.yaml

cd terraform

terraform apply -auto-approve

image-updater-argocd-image-updater-6c5996c77b-cbd2f   1/1     Running   0          33s

# check updater logs
kubectl logs -f -l app.kubernetes.io/instance=image-updater -n argocd

docker tag nginx:1.25.0 taviamcboa/nginx:v0.2.0
docker push taviamcboa/nginx:v0.2.0

```