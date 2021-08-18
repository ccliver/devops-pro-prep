ecs-cli configure --cluster "ecs-lab" --default-launch-type EC2 --config-name "ecs-lab" --region "us-east-1"
INFO[0000] Saved ECS CLI cluster configuration ecs-lab
ecs-cli configure --cluster "ecs-lab" --default-launch-type EC2 --config-name "ecs-lab" --region "us-east-1"
INFO[0000] Saved ECS CLI cluster configuration ecs-lab
cat .ecs/config 
ecs-cli up --keypair ./id_rsa --capability-iam --size 2 --instance-type t2.medium --cluster-config "ecs-lab" --ecs-profile "ecs-lab" --region "us-east-1"
aws sts get-caller-identity
ls
ecs-cli up --keypair ./id_rsa --capability-iam --size 2 --instance-type t2.medium --cluster-config "ecs-lab" --ecs-profile "ecs-lab" --region "us-east-1"
