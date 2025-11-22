eksctl create cluster \
    --name kubernets-cluster \
    --version 1.29 \
    --region ap-southeast-1 \
    --nodegroup-name linux-nodes \
    --node-type t3.small \
    --nodes 2 \
    --nodes-min 1 \
    --nodes-max 3

aws eks update-kubeconfig --name kubernets-cluster --region ap-southeast-1
cat /root/.kube/config