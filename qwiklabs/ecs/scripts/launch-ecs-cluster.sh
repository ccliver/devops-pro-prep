#!/bin/bash

REGION=$1

NAME="ecs-lab"
AWS_CLI_OPTIONS="--region ${REGION}"
VPC_ID=$(aws ec2 describe-vpcs --region $REGION | jq -r '.Vpcs[] | select(.InstanceTenancy=="default") | .VpcId')
SUBNET_A=$(aws ec2 describe-subnets --region $REGION | jq -r .Subnets[0].SubnetId)
SUBNET_B=$(aws ec2 describe-subnets --region $REGION | jq -r .Subnets[1].SubnetId)
AMI=$(aws ssm get-parameters --region ${REGION} --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended --query 'Parameters[0].Value' | jq -r 'fromjson .image_id')

aws ec2 import-key-pair --region $REGION --key-name ${NAME} --public-key-material fileb://id_rsa.pub

aws cloudformation create-stack $AWS_CLI_OPTIONS --stack-name $NAME \
    --template-body file:///root/cf/ecs-cluster.yml \
    --capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM CAPABILITY_IAM \
    --parameters ParameterKey=KeyName,ParameterValue=$NAME \
    ParameterKey=KeyName,ParameterValue=$NAME \
    ParameterKey=AMI,ParameterValue=$AMI \
    ParameterKey=VpcId,ParameterValue=$VPC_ID \
    ParameterKey=SubnetId,ParameterValue="$SUBNET_A\,$SUBNET_B"
