.DEFAULT_GOAL := help

REGION="us-east-1"
DOCKER_OPTIONS=-v ${PWD}:/work \
-w /work \
-it \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-e MY_IP=${MY_IP}
AWS_CLI_OPTIONS=--region ${REGION}
NAME="devops-domain1-lab"
PUBKEY=$(shell cat ~/.ssh/id_rsa.pub)
USER=cloud_user # Default user for acloudguru's AWS sandboxes
CREATE_PARAMS=--capabilities CAPABILITY_NAMED_IAM --on-failure DELETE
UPDATE_PARAMS=--capabilities CAPABILITY_NAMED_IAM

ifeq ($(origin UPDATE), undefined)
	OP=create
	PARAMS=${CREATE_PARAMS}
else
	OP=update
	PARAMS=${UPDATE_PARAMS}
endif

create_repo:  ## Create a CodeCommit repository with an admin and jr user
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws cloudformation ${OP}-stack \
		${AWS_CLI_OPTIONS} --stack-name ${NAME}-repo --template-body file:///work/cf/repo.yml \
		--parameters ParameterKey=RepoName,ParameterValue=${NAME} \
		${PARAMS}
	@sleep 10
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws iam upload-ssh-public-key \
		--user-name repo-user --ssh-public-key-body "${PUBKEY}"

clone_repo: ## Clone the repo and copy lab files into it
	@git clone \
		ssh://$(shell docker run ${DOCKER_OPTIONS} ccliver/awscli \
		aws iam list-ssh-public-keys --user-name repo-user | jq -r .SSHPublicKeys[0].SSHPublicKeyId)@git-codecommit.us-east-1.amazonaws.com/v1/repos/${NAME}
	cp -r lab-files/cicd-demo/* ./${NAME}/
	cd ./${NAME} && git add . && git commit . -m "initial setup" && git push
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws codebuild start-build --project-name ${NAME} --region ${REGION} > /dev/null

validate_templates: ## Check Cloudformation syntax
	@aws cloudformation validate-template --template-body file://cf/repo.yml || exit 0
	@aws cloudformation validate-template --template-body file://cf/build.yml || exit 0
	@aws cloudformation validate-template --template-body file://cf/deploy.yml || exit 0
	@aws cloudformation validate-template --template-body file://cf/pipeline.yml || exit 0

setup_codebuild: ## Create a CodeBuild project to build the lab app
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws cloudformation ${OP}-stack \
		${AWS_CLI_OPTIONS} --stack-name ${NAME}-build --template-body file:///work/cf/build.yml \
		--parameters ParameterKey=ProjectName,ParameterValue=${NAME} ParameterKey=Region,ParameterValue=${REGION} \
		  ParameterKey=User,ParameterValue=${USER} \
		${PARAMS}
	@sleep 20

launch_instance: ## Launch an instance to deploy the lab app to using CodeDeploy
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws cloudformation ${OP}-stack \
		${AWS_CLI_OPTIONS} --stack-name ${NAME}-deploy --template-body file:///work/cf/deploy.yml \
		--parameters ParameterKey=ProjectName,ParameterValue=${NAME} \
		${PARAMS}

create_pipeline: ## Create a CodePipeline pipeline to tie all of the developer tools together
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws cloudformation ${OP}-stack \
		${AWS_CLI_OPTIONS} --stack-name ${NAME}-pipeline --template-body file:///work/cf/pipeline.yml \
		--parameters ParameterKey=ProjectName,ParameterValue=${NAME} \
		${PARAMS}

get_url: ## Output the url for the lab app
	@echo "http://$(shell aws ec2 describe-instances --region us-east-1 --filters "Name=tag:Environment,Values=Test" --query "Reservations[0].Instances[0].[PublicIpAddress]" --output text)/index.html"

cleanup_lab: ## Cleanup local lab files
	@aws cloudformation delete-stack --stack-name ${NAME}-repo
	@aws cloudformation delete-stack --stack-name ${NAME}-build
	@aws cloudformation delete-stack --stack-name ${NAME}-deploy
	@rm -rf ./${NAME}

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
