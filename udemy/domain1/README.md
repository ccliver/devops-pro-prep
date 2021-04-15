## Setup lab
```bash
# `export` AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY into your environment
# CodeCommit repo grants access to IAM user `repo-user` with SSH key `~/.ssh/id_rsa`


# Create the repo and push the lab code up
make create_repo
make clone_repo
```
