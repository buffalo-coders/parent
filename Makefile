###
# #%L
# org.buffalo-coders:parent
# %%
# Copyright (C) 2018 - 2019 Buffalo Coders
# %%
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# #L%

default: install

.PHONY: clean
clean:
	@mvn clean

.PHONY: deploy
deploy: gpg-init
	@mvn --activate-profiles sonatype-oss-release deploy

.PHONY: display-updates
display-updates:
	@mvn -Dmaven.version.rules=file://$(CURDIR)/src/main/resources/rules.xml \
		versions:display-dependency-updates \
		versions:display-parent-updates \
		versions:display-plugin-updates \
		versions:display-property-updates

.PHONY: fix-pom
fix-pom: no-git-changes
	@mvn tidy:pom

.PHONY: fix-license
fix-license: no-git-changes
	@mvn license:update-file-header license:update-project-license
	@mvn -Dlicense.roots=. -Dlicense.includes=pom.xml,Dockerfile,Jenkinsfile,Makefile license:update-file-header

.PHONY: gpg-init
gpg-init:
	@echo "Setting up GPG."
	$(eval TMP := $(shell mktemp))
	touch $(TMP)
	gpg -ab $(TMP)
	rm $(TMP) $(TMP).asc

.PHONY: install
install:
	@mvn install

no-git-changes:
	@git diff --quiet --exit-code
	@git diff --quiet --exit-code --cached
