SERVICE ?= pickapp
AWS_REGION ?= eu-west-1

BUCKET_NAME = hack-the-crisis
BUCKET_PREFIX = backend
SWAGGER_PATH = s3://$(BUCKET_NAME)/$(BUCKET_PREFIX)/swagger/swagger.yml

OWNER = pickAppTeam

REPOS = $(shell git config --get remote.origin.url)
REV = $(shell git rev-parse HEAD)

.PHONY: deploy_auth
deploy-auth:
	aws cloudformation deploy \
	--tags Owner=${OWNER} Project=$(SERVICE) Repository=$(REPOS) git-sha=$(REV) \
	--template-file ./cloudformation/authentication.yml \
	--stack-name $(SERVICE)-auth \
	--capabilities CAPABILITY_NAMED_IAM \aws s3 cp cloudformation/swagger.yml $(SWAGGER_PATH)
	--region $(AWS_REGION) \
	--no-fail-on-empty-changeset \
	--parameter-overrides \
	Service=$(SERVICE)

.PHONY: deploy_serverless
deploy_serverless:
	aws s3 cp cloudformation/swagger.yml $(SWAGGER_PATH)
	make install
	$(call cfn-deploy,serverless)

cfn-package = mkdir -p cloudformation/dist && \
	aws cloudformation package \
	--template-file cloudformation/${1}.yml \
	--output-template-file cloudformation/dist/${1}.yml \
	--s3-bucket $(BUCKET_NAME) \
	--s3-prefix $(SERVICE)

cfn-deploy = $(call cfn-package,${1}) && \
	aws cloudformation deploy \
	--tags Owner=${OWNER} Project=$(SERVICE) Repository=$(REPOS) git-sha=$(REV) \
	--template-file cloudformation/dist/${1}.yml \
	--stack-name $(SERVICE)-${1} \
	--capabilities CAPABILITY_NAMED_IAM \
	--region $(AWS_REGION) \
	--no-fail-on-empty-changeset \
	--parameter-overrides \
		Service=$(SERVICE) \
		Swagger=$(SWAGGER_PATH)
