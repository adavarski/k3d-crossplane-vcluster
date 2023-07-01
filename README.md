## Using Crossplane to deploy ArgoCD on vcluster

### Objective: 
How We Securely Scaled Multi-Tenancy with VCluster, Crossplane, and Argo CD.

### Explanation: 
What do you do when RBAC with namespaces aren’t enough to meet your multi-tenancy needs? Namespaces are easy to implement but they generally do not provide the level of isolation that is needed when working with external users. Instead of running multiple clusters, which are complex to manage, hard to scale and often costly, we turned to vCluster. vCluster is an open source project that allows you to create virtual clusters in any Kubernetes cluster. Virtual clusters enjoy higher isolation than simple namespaces and can also be used for cluster level resources like CRDs without any versioning conflicts. Using virtual clusters in the Codefresh’s hosted GitOps platform that is powered by thousands of Argo instances we enabled high isolation between tenants while lowering the cost of application multi-tenancy. For most companies, multi-tenancy means supporting multiple teams within an organization, or perhaps a partner. For us, multi-tenancy means providing access to the general public. We needed to go deeper than RBAC, namespaces, and auditing. In this end-user talk, we’ll share how we leveraged vCluster, Crossplane, and Argo CD to approach multi-tenancy, scale, and security in a totally GitOps fashion. You’ve never seen vCluster scale like this before.

### Architecture:
![Architecture](./pictures/architecture.png "Architecture")

Run your own [k3d](https://k3d.io/) cluster with [Crossplane](https://www.crossplane.io/) and deploy [ArgoCD](https://argoproj.github.io/cd/) instances onto [vclusters](https://www.vcluster.com/)

---
### Dependencies

- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [k3d](https://k3d.io/#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Helm](https://helm.sh/docs/intro/install/)

---
## What's in this repository?
1. [Initialization script](scripts/init-k3d-demo-env.sh) - deploys k3d cluster and installs ArgoCD onto it. It also applies the [argocd-applications](argocd-applications) to this cluster.
2. [crossplane-resources](crossplane-resources) - Contains the providers required to deploy our virtualargocd composite resource, along with the [definition](crossplane-resources/xvirtualargocd/definition.yaml) and the [composition](crossplane-resources/xvirtualargocd/composition.yaml)
3. [virtualargocds](virtualargocds) - contains the composite resource claims. Here we will define all instances of the composition to be created.
4. [argocd-applications](argocd-applications) - contains ArgoCD applications so that ArgoCD syncs it all to the cluster. One of the ArgoCD appplications deploys crossplane itself to the cluster.
---
## How to run the demo?
1. Fork the repo
2. Replace repository URL in [crossplane-resources.yaml](argocd-applications/crosspalne-resources.yaml) and in [virtual-argocds.yaml](argocd-applications/virtual-argocds.yaml). 
3. Execute [initializtion script](scripts/init-k3d-demo-env.sh).
4. Once all ArgoCD applications are synced, uncomment [customer2.yaml](virtualargocds/customer2.yaml), see that a namespace is created, with vcluster and ArgoCD deployed onto it.


### Access ArgoCD UI: 

Browser: http://argocd.192.168.1.99.nip.io:8888

### Screenshots:

<img src="pictures/k3d-crossplane-argo-apps.png?raw=true" width="900">

<img src="pictures/k3d-crossplane-argo-app-crossplane.png?raw=true" width="900">

<img src="pictures/k3d-crossplane-argo-crossplane-resources.png?raw=true" width="900">

<img src="pictures/k3d-crossplane-arg-virtualargocd.png?raw=true" width="900">

REF: 

- Demo video: https://www.youtube.com/watch?v=hFiHU6W4_z0
- Demo repo: https://github.com/codefresh-contrib/demo-crossplane-vcluster
- https://github.com/janwillies/virtual-k8s-argocd
- https://github.com/iam-veeramalla/k8s-crossplane-argocd
- etc.



