#!/bin/bash
set -euo pipefail

AWS_REGION=${AWS_REGION:-$AWS_DEFAULT_REGION}
EKS_CLUSTER=${EKS_CLUSTER:-$EKS_CLUSTER}
IMAGE_URI=${IMAGE_URI:-$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG}
DEPLOYMENT_NAME=brain-tasks-app
NAMESPACE=${NAMESPACE:-default}

echo "Update kubeconfig..."
aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER

echo "Set image to $IMAGE_URI"
kubectl -n $NAMESPACE set image deployment/$DEPLOYMENT_NAME $DEPLOYMENT_NAME=$IMAGE_URI --record
kubectl -n $NAMESPACE rollout status deployment/$DEPLOYMENT_NAME

