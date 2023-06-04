# helm install image-updater -n argocd argo/argocd-image-updater --version 0.9.1 -f terraform/values/argocd-image-updater.yaml

resource "helm_release" "image-updater" {
  name             = "image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = true
  version          = "0.9.1"
  #   set {
  #     name  = "service.type"
  #     value = "ClusterIP"
  #   }
  values = ["${file("values/argocd-image-updater.yaml")}"]
}