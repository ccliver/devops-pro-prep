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
NAME="devops-domain2-lab"

show_eb_solution_stacks: ## Output the list of available ElasticBeanlstalk solution stacks
	@aws elasticbeanstalk list-available-solution-stacks

create_eb_environment: ## Creates an ElasticBeanstalk 
	@mkdir ${NAME}-hello-world
	@docker run ${DOCKER_OPTIONS} -w /work/${NAME}-hello-world ccliver/awscli eb init \
		${EB_CLI_OPTIONS} ${NAME}-hello-world \
		-p "64bit Amazon Linux 2 v3.3.2 running PHP 8.0"
	@echo "Hello World" >> ${NAME}-hello-world/index.html
	@docker run ${DOCKER_OPTIONS} -w /work/${NAME}-hello-world ccliver/awscli eb create \
		${EB_CLI_OPTIONS} ${NAME}-hello-world

create_saved_configuration: ## Take a backup of the EB environment configuration
	@docker run ${DOCKER_OPTIONS} -w /work/${NAME}-hello-world ccliver/awscli eb config save ${NAME}-hello-world

cleanup_lab: ## Delete AWS resources and cleanup local environment
	@rm -rf ${NAME}-hello-world
	@rm -rf .elasticbeanstalk
	@aws elasticbeanstalk delete-application --application-name ${NAME}-hello-world --terminate-env-by-force

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
