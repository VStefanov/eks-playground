resource "helm_release" "istiod" {
    name="istiod-release"
    
    repository       = "https://istio-release.storage.googleapis.com/charts"
    chart            = "istiod"
    namespace        = "istio-system"
    create_namespace = true
    version          = "1.18.0"

    set {
        name  = "global.istioNamespace"
        value = "istio-system"
    }

    set {
        name  = "telemetry.enabled"
        value = "true"
    }

    set {
        name  = "meshConfig.ingressSelector"
        value = "gateway"
    }

    depends_on = [ helm_release.istio_base ]
}