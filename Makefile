deploy-auth:
	@aws cloudformation deploy --template-file ./cloudformation/authentication.yml --stack-name pickapp-auth