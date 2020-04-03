deploy-auth:
	@aws cloudformation deploy --template-file ./authentication.yml --stack-name pickapp-auth