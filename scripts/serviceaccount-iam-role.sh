#!/bin/sh

# Create an OIDC provider for the cluster
eksctl utils associate-iam-oidc-provider --cluster=clo835 --approve

ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_PROVIDER=$(aws eks describe-cluster --name clo835 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
NAMESPACE=final
SERVICE_ACCOUNT=clo835
#create the oidc trusted relationship file
read -r -d '' TRUST_RELATIONSHIP <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:aud": "sts.amazonaws.com",
          "${OIDC_PROVIDER}:sub": "system:serviceaccount:${NAMESPACE}:${SERVICE_ACCOUNT}"
        }
      }
    }
  ]
}
EOF
echo "${TRUST_RELATIONSHIP}" > trust.json
#create the iam role
OUT=$(aws iam create-role --role-name clo835-service-account-role --assume-role-policy-document file://trust.json)
echo $OUT
rm trust.json
#attach the s3 read only access policy to the role
#aws iam attach-role-policy --role-name sa-iam-role --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam put-role-policy --role-name clo835-service-account-role --policy-name SA-S3ReadAccess --policy-document file://s3-policy.json