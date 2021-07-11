## Create a pipeline that deploys the sample app to an EC2 instance on updates to master. Integrates CodeCommit, CodeBuild, CodeDeploy, and CodePipeline

### Available build steps
```bash
# NOTE: set environment variable UPDATE to update a stack: UPDATE=true make launch_instance
$ make
create_repo                    Create a CodeCommit repository with an admin and jr user
clone_repo                     Clone the repo and copy lab files into it
validate_templates             Check Cloudformation syntax
setup_codebuild                Create a CodeBuild project to build the lab app
launch_instance                Launch an instance to deploy the lab app to using CodeDeploy
create_pipeline                Create a CodePipeline pipeline to tie all of the developer tools together
cleanup_lab                    Cleanup local lab files
```

### Steps
* `export` `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` into your environment
* Create the CodeCommit repo: `make creat_repo`. Note, CodeCommit repo grants access to IAM user `repo-user` with SSH key `~/.ssh/id_rsa`
* Clone the repo and add lab files: `make clone_repo`
* Create the CodeBuild project: `make setup_codebuild`
* Launch an instance to run the app: `make launch_instance`
* Create a pipeline in CodePipeline to link all the dev tools together: `make create_pipeline`
* Once the pipeline is finished you can access the lab server via the URL from `make get_url`
* Make a change to index.html in the lab repo: `cd ./devops-domain1-lab && vim index.html && git commit . -m 'testing' && git push`
* Wait for the pipeline to complete and verify the change was deployed: `make get_url`

### Cleanup
* Cleanup the local environment and Cloudformation stacks: `make cleanup_lab`
