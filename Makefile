PYTHON_INTERPRETER=python3
VENV_PATH=.venv
PIP=$(VENV_PATH)/bin/pip
FLAKE=$(VENV_PATH)/bin/flake8
PYTEST=$(VENV_PATH)/bin/pytest
SPHINX_RELOAD=$(VENV_PATH)/bin/python sphinx_reload.py
TWINE=$(VENV_PATH)/bin/twine
PACKAGE_NAME=sveetch-python-sample
APPLICATION_NAME=sample

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo
	@echo "  install             -- to install this project with virtualenv and Pip"
	@echo ""
	@echo "  clean               -- to clean EVERYTHING (Warning)"
	@echo "  clean-doc       -- to remove documentation builds"
	@echo "  clean-pycache       -- to remove all __pycache__, this is recursive from current directory"
	@echo "  clean-install       -- to clean Python side installation"
	@echo ""
	@echo "  livedocs            -- to run livereload server to rebuild documentation on source changes"
	@echo ""
	@echo "  flake               -- to launch Flake8 checking"
	@echo "  tests               -- to launch base test suite using Pytest"
	@echo "  quality             -- to launch Flake8 checking and every tests suites"
	@echo ""
	@echo "  release             -- to release package for latest version on PyPi (once release has been pushed to repository)"
	@echo

clean-pycache:
	rm -Rf .pytest_cache
	find . -type d -name "__pycache__"|xargs rm -Rf
	find . -name "*\.pyc"|xargs rm -f
.PHONY: clean-pycache

clean-install:
	rm -Rf $(VENV_PATH)
	rm -Rf $(PACKAGE_NAME).egg-info
.PHONY: clean-install

clean-doc:
	rm -Rf docs/_build
.PHONY: clean-doc

clean: clean-doc clean-install clean-pycache
.PHONY: clean

venv:
	virtualenv -p $(PYTHON_INTERPRETER) $(VENV_PATH)
	# This is required for those ones using old distribution
	$(PIP) install --upgrade pip
	$(PIP) install --upgrade setuptools
.PHONY: venv

install: venv
	$(PIP) install -e .[dev]
.PHONY: install

livedocs:
	$(SPHINX_RELOAD)
.PHONY: livedocs

flake:
	$(FLAKE) --show-source $(APPLICATION_NAME)
	$(FLAKE) --show-source tests
.PHONY: flake

tests:
	$(PYTEST) -vv tests/
.PHONY: tests

quality: tests flake
.PHONY: quality

release:
	rm -Rf dist
	$(VENV_PATH)/bin/python setup.py sdist
	$(TWINE) upload dist/*
.PHONY: release
