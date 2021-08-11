.DEFAULT_GOAL := help

REGION="us-east-1"
DOCKER_OPTIONS=-v ${PWD}:/work \
-w /work \
-it \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-e MY_IP=${MY_IP}
AWS_CLI_OPTIONS=--region ${REGION}
EB_CLI_OPTIONS=--region ${REGION}
NAME="eb-lab-blue-green"
#SOLUTION_STACK_NAME="64bit Amazon Linux 2 v3.3.4 running PHP 8.0"
CREATE_PARAMS=--capabilities CAPABILITY_NAMED_IAM --on-failure DELETE
UPDATE_PARAMS=--capabilities CAPABILITY_NAMED_IAM

ifeq ($(origin UPDATE), undefined)
	OP=create
	PARAMS=${CREATE_PARAMS}
else
	OP=update
	PARAMS=${UPDATE_PARAMS}
endif

show_eb_solution_stacks: ## Output the list of available ElasticBeanlstalk solution stacks
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws elasticbeanstalk list-available-solution-stacks ${AWS_CLI_OPTIONS} --query "SolutionStacks" | grep 'PHP 8'| sort

create_eb_environment: ## Creates an ElasticBeanstalk 
	@mkdir ${NAME}-hello-world
	@docker run ${DOCKER_OPTIONS} -w /work/${NAME}-hello-world ccliver/awscli eb init \
		${EB_CLI_OPTIONS} ${NAME}-hello-world \
		-p ${SOLUTION_STACK_NAME}
	@echo "Hello World" >> ${NAME}-hello-world/index.html
	@docker run ${DOCKER_OPTIONS} -w /work/${NAME}-hello-world ccliver/awscli eb create \
		${EB_CLI_OPTIONS} ${NAME}-hello-world

create_saved_configuration: ## Take a backup of the EB environment configuration
	@docker run ${DOCKER_OPTIONS} -w /work/${NAME}-hello-world ccliver/awscli eb config save ${NAME}-hello-world

create_blue_green_eb_lab: ## Deploy a blue/green Elastic Beanstalk lab
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws s3api create-bucket --bucket ccliver-eb-lab-blue-green-artifacts
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws s3 cp lab-files/blue-artifact.zip s3://ccliver-eb-lab-blue-green-artifacts/
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws s3 cp lab-files/green-artifact.zip s3://ccliver-eb-lab-blue-green-artifacts/
	@docker run ${DOCKER_OPTIONS} ccliver/awscli aws cloudformation ${OP}-stack \
		${AWS_CLI_OPTIONS} --stack-name ${NAME} --template-body file:///work/cf/blue-green-eb.yml \
		--parameters ParameterKey=SolutionStackName,ParameterValue="$(shell docker run ${DOCKER_OPTIONS} ccliver/awscli aws elasticbeanstalk list-available-solution-stacks ${AWS_CLI_OPTIONS} --query "SolutionStacks" | grep 'PHP 8'| sort | tail -n 1 | cut -d '"' -f 2)" \
		${PARAMS}

cleanup_lab: ## Delete AWS resources and cleanup local environment
	@rm -rf ${NAME}-hello-world
	@rm -rf .elasticbeanstalk
	@aws elasticbeanstalk delete-application --application-name ${NAME}-hello-world --terminate-env-by-force

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
