key_name = todo-deploy-elasticbeanstalk-cloudformation
stack_name = todo-deploy
bucket_name = todo-deploy-packages
package_name = todo-app.zip

up:
	git clone https://github.com/todo-deploy/todo-app.git && \
	cd todo-app && \
	zip -r ../$(package_name) * && \
	cd .. && \
	aws ec2 create-key-pair --key-name $(key_name) --region us-west-2 && \
	aws s3 mb s3://$(bucket_name) && \
	aws s3 cp $(package_name) s3://$(bucket_name)/$(package_name) && \
	aws cloudformation create-stack \
	--stack-name $(stack_name) \
	--template-body file://todoapp.template \
	--parameters \
	ParameterKey=KeyPairName,ParameterValue=$(key_name) \
	ParameterKey=BucketName,ParameterValue=$(bucket_name) \
	ParameterKey=PackageName,ParameterValue=$(package_name) \
	--capabilities CAPABILITY_IAM \
	--region us-west-2

down:
	aws cloudformation delete-stack --stack-name $(stack_name) && \
	aws ec2 delete-key-pair --key-name $(key_name)