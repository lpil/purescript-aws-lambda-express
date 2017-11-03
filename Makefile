export PATH := ./node_modules/.bin:$(PATH)


.PHONY: help
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: install
install:
	npm install
	bower install


.PHONY: test
test: ## Run the test watcher
	pulp test


.PHONY: test-watch
test-watch: ## Run the tests once
	pulp --watch test


.PHONY: build-watch
build-watch: ## Incrementally compile the project
	pulp --watch build --include src:test


.PHONY: build
build: ## Compile the project once
	pulp build --include src:test


.PHONY: run-watch
run-watch: ## Run test when files change
	pulp --watch run


.PHONY: deploy
deploy: build ## Deploy Test.Main, for testing
	sls deploy


.PHONY: deploy-remove
deploy-remove: ## Remove AWS resources used by deploy
	sls remove


.PHONY: clean
clean: ## Delete compiled artefacts
	rm -fr output
