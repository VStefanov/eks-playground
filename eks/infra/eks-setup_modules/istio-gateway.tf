resource "helm_release" "istio_gateway" {
    name="istio-gateway-release"
    
    repository       = "https://istio-release.storage.googleapis.com/charts"
    chart            = "gateway"
    namespace        = "istio-ingress"
    create_namespace = true
    version          = "1.18.0"

    depends_on = [ 
        helm_release.istio_base,
        helm_release.istiod
    ]
}