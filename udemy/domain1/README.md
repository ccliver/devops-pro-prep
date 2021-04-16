## Setup lab
```bash
create_repo                    Create a CodeCommit repository with an admin and jr user
clone_repo                     Clone the lab repo
cleanup_lab                    Cleanup local lab files
```

```bash
# `export` AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY into your environment
# CodeCommit repo grants access to IAM user `repo-user` with SSH key `~/.ssh/id_rsa`


# Create the repo and push the lab code up
make create_repo
make clone_repo


# Cleanup local workspace
make cleanup_lab
```

