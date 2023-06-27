resource "helm_release" "istio_base" {
    name="istio-base-release"
    
    repository       = "https://istio-release.storage.googleapis.com/charts"
    chart            = "base"
    namespace        = "istio-system"
    create_namespace = true
    version          = "1.18.0"

    set {
        name  = "global.istioNamespace"
        value = "istio-system"
    }
}