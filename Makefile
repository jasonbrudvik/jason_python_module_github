###############################################################################
# This makefile is made to simplify development work
###############################################################################

# Makefile stuff
.DEFAULT_GOAL := help
SHELL := /bin/bash
.ONESHELL:
THIS_FILE := $(lastword $(MAKEFILE_LIST))

# Set the umask so that everyone has atleast read access to results
UMASK := umask 002

# Colors
LIGHTPURPLE := \033[1;35m
GREEN := \033[32m
CYAN := \033[36m
BLUE := \033[34m
RED := \033[31m
NC := \033[0m

# Separator between output, 80 characters wide
define print_separator
	printf "$1"; printf "%0.s*" {1..80}; printf "$(NC)\n"
endef
print_line_green = $(call print_separator,$(GREEN))
print_line_blue = $(call print_separator,$(BLUE))
print_line_red = $(call print_separator,$(RED))


###############################################################################
##@ Help
###############################################################################

.PHONY: help

help:  ## Display this help message
	@printf "\n"
	$(print_line_blue)
	printf "$(BLUE)Jupyter Notebook and Kernel Validation $(CYAN)Makefile$(NC)\n"
	printf "    This makefile has been created to simplify development \n"
	printf "    work on Jupyter notebook and kernel validation routines.\n"
	$(print_line_blue)
	printf "\n"
	$(print_line_blue)
	printf "$(BLUE)Usage\n    $(CYAN)make $(NC)<target>\n"
	awk 'BEGIN {FS = ":.*##";} /^[a-zA-Z_-].*##/ \
	{ printf "    $(CYAN)%-27s$(NC) %s\n", $$1, $$2} /^##@/ \
	{ printf "\n$(BLUE)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	$(print_line_blue)


###############################################################################
##@ Development
###############################################################################

.PHONY: venv clean-venv hdf5-kernel cli-execution

# Define the name of the virtual environment directory
VENV := venv

# Installation of conda & required modules
$(VENV)/bin/activate: development/venv-requirements.yml
	@printf "\n"
	$(MAKE) -s -f $(THIS_FILE) clean-venv

	miniconda_installer=Miniconda3-py39_4.12.0-Linux-x86_64.sh
	miniconda_url="https://repo.anaconda.com/miniconda/$$miniconda_installer"

	$(print_line_blue)
	printf "\n$(BLUE)Downloading miniconda from $$miniconda_url$(NC)\n"
	wget $$miniconda_url

	printf "\n$(BLUE)Installing miniconda from $$miniconda_installer$(NC)\n"
	sh $$miniconda_installer -s -p $(VENV) -b
	rm $$miniconda_installer

	printf "\n$(BLUE)Installing development requirements$(NC)\n"
	./$(VENV)/bin/conda env update \
		--name base \
		--file development/venv-requirements.yml

	printf "\n$(BLUE)Installing jason_python_module_github$(NC)\n"
	./$(VENV)/bin/pip install -e .

	printf "\n$(GREEN)DONE INSTALLING VENV$(NC)\n"
	printf "  activate environment:    source $(VENV)/bin/activate \n"
	printf "  deactivate environment:  conda deactivate\n"
	printf "  remove environment:      rm -rf $(VENV)\n"
	$(print_line_green)
	printf "\n"

venv: $(VENV)/bin/activate ## Create virtual environment with conda

cli-execution: $(KERNEL_SPEC_FILE) ## Test CLI execution with example input 
	source $(VENV)/bin/activate
	jason_python_module_github --hello Jason	

clean-venv: ## Remove virtual environment
	rm -rf $(VENV)
	find . -type f -name '*.pyc' -delete
	rm -rf .tox


###############################################################################
##@ Testing
###############################################################################

.PHONY: tox-lint tox-build-cli-tests tox-hello-tests tox-bye-tests clean-test

tox-lint: $(VENV)/bin/activate ## Lint python code
	source $(VENV)/bin/activate
	tox -r -e lint

tox-build-cli-tests: $(VENV)/bin/activate ## Run build tests 
	source $(VENV)/bin/activate
	tox -e "py3{6,7,8,9}-build-cli-tests"

tox-hello-tests: $(VENV)/bin/activate ## Run hello tests
	source $(VENV)/bin/activate
	tox -e "py3{6,7,8,9}-hello-tests"

tox-bye-tests: $(VENV)/bin/activate ## Run bye tests
	source $(VENV)/bin/activate
	tox -e "py3{6,7,8,9}-bye-tests"

clean-test: ## Remove tox and pytest files
	rm -rf .tox .pytest_cache

###############################################################################
##@ Building
###############################################################################

.PHONY: build upload clean-build bump-version changelog

BUILD_OUTPUT_FILE := dist/jason_python_module_github-*.tar.gz

# Building of the module package
$(BUILD_OUTPUT_FILE): $(VENV)/bin/activate setup.cfg
	rm -rf dist build jason_python_module_github.egg-info
	source $(VENV)/bin/activate
	python3 setup.py sdist bdist_wheel

# build is a shortcut target
build: $(BUILD_OUTPUT_FILE) ## Build the module package 

bump-version: ## Set version number & git tag - today's date plus count for today
	@printf "\n"

	# Create the version number from today's date
	datestamp=`date +"%Y.%-m.%-d"`
	daycommitcount=`git tag --list $$datestamp* | wc -w`
	versiontag=$${datestamp}
	if [ "$$daycommitcount" -gt 0 ]; then
		versiontag=$${datestamp}.$${daycommitcount}
	fi

	$(print_line_blue)
	printf "$(CYAN)datestamp:       $(NC)$$datestamp\n"
	printf "$(CYAN)daycommitcount:  $(NC)$$daycommitcount\n"
	printf "$(CYAN)versiontag:      $(NC)$$versiontag\n"
	$(print_line_blue)
	printf "\n"

	# Set package version number
	$(print_line_blue)
	printf "$(CYAN)Changing version in setup.cfg$(NC)\n\n"
	sed -i "/^version =.*/ s//version = $$versiontag/" setup.cfg
	printf "$(CYAN)New version of setup.cfg: $(NC)\n"
	cat setup.cfg
	$(print_line_blue)
	printf "\n"

	# Update changelog after a new tag is created, so that all the recent
	# commit information is in it
	git tag $$versiontag
	$(MAKE) -s -f $(THIS_FILE) changelog

	# Make a git commit
	$(print_line_blue)
	printf "$(CYAN)Commit changes$(NC)\n\n"
	git add -A
	git commit -m "bumped version in setup.cfg to $$versiontag"
	$(print_line_blue)
	printf "\n"

	# Set git tag to be the same as the package version number
	$(print_line_blue)
	printf "$(CYAN)Setting new git tag:$(NC)\n  $$versiontag\n"
	# Some trickery with tags inorder to have most recent info in the changelog
	git tag -d $$versiontag
	git tag $$versiontag
	printf "\n$(CYAN)List of git tags:$(NC)\n"
	git tag
	$(print_line_blue)
	printf "\n"

	# Do not push - allow time for checks to be made first
	$(print_line_blue)
	printf "$(CYAN)If everything looks ok, push to github:$(NC)\n"
	printf "  git push origin main\n"
	printf "  git push origin $$versiontag\n"
	$(print_line_blue)
	printf "\n"

changelog: ## Generate simple changelog from git tags and commits
	@printf "\n"
	$(print_line_blue)

	previous_tag=0
	printf "# jason_python_module_github CHANGELOG\n\n" > CHANGELOG.md

	# Loop over tags, oldest to newest
	for current_tag in `git tag --sort=-creatordate`
	do
		if [ "$$previous_tag" != 0 ];then
			# Print the current tag and date of the tag
			tag_date=`git log -1 --pretty=format:'%ad' --date=short $${previous_tag}`
			printf "## $${previous_tag} ($${tag_date})\n\n" >> CHANGELOG.md

			# Print all commit messages between this tag and the previous
			git log $${current_tag}...$${previous_tag} --pretty=format:'*  %s [View](https://gitlab.com/MAXIV-SCISW/JUPYTERHUB/jason_python_module_github/-/commit/%H)' --reverse | grep -v Merge >> CHANGELOG.md
			printf "\n\n" >> CHANGELOG.md
		fi
		previous_tag=$${current_tag}
	done

	printf "$(GREEN)Done generating CHANGELOG.md$(NC)\n"
	$(print_line_blue)
	printf "\n"

upload-testpypi: $(BUILD_OUTPUT_FILE) ## Upload the module to TestPyPi
	@printf "\n"
	source $(VENV)/bin/activate
	python3 -m twine upload --repository testpypi dist/*

upload-pypi: $(BUILD_OUTPUT_FILE) ## Upload the module to PyPi
	@printf "\n"
	source $(VENV)/bin/activate
	python3 -m twine upload --repository pypi dist/*

clean-build: ## Remove build files
	rm -rf dist build jason_python_module_github.egg-info
