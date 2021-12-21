# Provision EKS Cluster

This repo containing Terraform configuration files to provision an EKS cluster on AWS.

## Set up and initialize your Terraform workspace

```bash
git clone https://github.com/marublaize/provision-eks-cluster
cd provision-eks-cluster
terraform init
```

1. **vpc.tf** provisions a VPC, subnets and availability zones using the AWS VPC Module. A new VPC is created for this tutorial so it doesn't impact your existing cloud environment and resources.

2. **security-groups.tf** provisions the security groups used by the EKS cluster.

3. **eks-cluster.tf** provisions all the resources (AutoScaling Groups, etc...) required to set up an EKS cluster using the AWS EKS Module.

4. **outputs.tf** defines the output configuration.

5. **versions.tf** sets the Terraform version to at least 0.14. It also sets versions for the providers used in this sample.

## Provisioning the cluster

This process should take approximately 10 minutes to be complete.

```bash
terraform plan
terraform apply -auto-approve
```

## Configure kubectl

```bash
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

## Configure cluster monitoring

### Deploy Kubernetes Metrics Server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get deployment metrics-server -n kube-system
```

### Kubernetes Dashboard

1. Deploy the Kubernetes Dashboard:

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
    ```

    <!-- ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
    ``` -->

2. Create a **ClusterRoleBinding** and provide an authorization token. This gives the **cluster-admin** permission to access the kubernetes-dashboard:

    ```bash
    kubectl apply -f dashboard-admin-user.yaml
    ```

3. Generate the authorization token:

    ```bash
    kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
    ```

4. Create a proxy server that will allow you to navigate to the dashboard from the browser on your local machine. This will continue running until you stop the process:

    ```bash
    kubectl proxy
    ```

5. You should be able to access and login to the [Kubernetes Dashboard](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/).

## Control plane metrics with Prometheus

### Viewing the raw metrics

To view the raw metrics output, use ```kubectl get --raw /metrics```. This command allows you to pass any HTTP path and returns the raw response.

ThE raw output returns verbatim what the API server exposes. These metrics are represented in a Prometheus format.

### Deploying Prometheus with Helm V3

1. Create a Prometheus namespace:

    ```kubectl create namespace prometheus```

2. Add the prometheus-community chart repository:

    ```bash
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    ```

3. Deploy Prometheus:

    ```bash
    helm upgrade -i prometheus prometheus-community/prometheus \
        --namespace prometheus \
        --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
    ```

4. Use ```kubectl get pods -n prometheus``` to verify that all of the pods in the prometheus namespace are in the READY state.

5. Use ```kubectl --namespace=prometheus port-forward deploy/prometheus-server 9090``` to port forward the Prometheus console to your [local machine](localhost:9090). All of the Kubernetes endpoints that are connected to Prometheus using service discovery are displayed.
