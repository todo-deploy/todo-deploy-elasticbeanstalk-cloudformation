# todo-deploy-elasticbeanstalk-cloudformation

This is part of the [todo-deploy](https://tododeploy.com) project

### Prerequisites

- [aws cli](https://aws.amazon.com/cli/)
- [eb cli](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html)

### Running

1. Create a new Organization on your mongoDB acocunt
2. `export TF_VAR_mongodb_atlas_org_id=...`
3. `export TF_VAR_mongodb_atlas_username=...`
4. `export TF_VAR_mongodb_atlas_api_key=...`
5. Create an S3 bucket for terraform state and put it's name in the `backend.tf` file in the `bucket` field.
6. `make up`