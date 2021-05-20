## Setup lab

### Available build steps
```bash
# NOTE: set environment variable UPDATE to update a stack: UPDATE=true make launch_instance
$ make
create_repo                    Create a CodeCommit repository with an admin and jr user
clone_repo                     Clone the repo and copy lab files into it
validate_templates             Check Cloudformation syntax
setup_codebuild                Create a CodeBuild project to build the lab app
launch_instance                Launch an instance to deploy the lab app to using CodeDeploy
cleanup_lab                    Cleanup local lab files
```

### Steps
* `export` `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` into your environment
* Create the CodeCommit repo: `make creat_repo`. Note, CodeCommit repo grants access to IAM user `repo-user` with SSH key `~/.ssh/id_rsa`
* Clone the repo and add lab files: `make clone_repo`
* Create the CodeBuild project: `make setup_codebuild`
* Launch an instance to run the app: `make launch_instance`

### Cleanup
* Cleanup the local environment and Cloudformation stacks: `make cleanup_lab`
