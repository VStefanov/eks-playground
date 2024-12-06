resource "helm_release" "app_mesh_controller" {
    name="appmesh-controller"
    
    repository       = "https://aws.github.io/eks-charts"
    chart            = "appmesh-controller"
    namespace        = "appmesh-system"
    create_namespace = true

    set {
        name  = "fullnameOverride"
        value = "appmesh-controller"
    }
}