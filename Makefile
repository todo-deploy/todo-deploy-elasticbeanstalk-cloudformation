key_name = todo-deploy-elasticbeanstalk-cloudformation
stack_name = todo-deploy
bucket_name = todo-deploy-packages
package_name = todo-app.zip

up: clean
	git clone https://github.com/todo-deploy/todo-app.git && \
	cd todo-app && \
	zip -r ../$(package_name) * && \
	cd .. && \
	aws ec2 create-key-pair --key-name $(key_name) --region us-west-2 && \
	aws s3 mb s3://$(bucket_name) && \
	aws s3 cp $(package_name) s3://$(bucket_name)/$(package_name) && \
	aws s3 mb s3://todo-deploy-cloudformation && \
	aws s3 sync templates s3://todo-deploy-cloudformation && \
	aws cloudformation deploy \
	--stack-name $(stack_name) \
	--template-file todoapp.template \
	--parameter-overrides \
	KeyPairName=$(key_name) \
	BucketName=$(bucket_name) \
	PackageName=$(package_name) \
	--capabilities CAPABILITY_IAM \
	--region us-west-2

down:
	aws cloudformation delete-stack --stack-name $(stack_name) && \
	aws s3 rb s3://$(bucket_name) --force && \
	aws s3 rb s3://todo-deploy-cloudformation --force && \
	aws ec2 delete-key-pair --key-name $(key_name)

clean:
	rm -rf $(package_name) && \
	rm -rf todo-app/