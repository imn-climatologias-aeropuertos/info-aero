POETRY=poetry run
FLET=flet run -d -r

SOURCE_FILES=$(shell find . -path "./src/*.py")
TEST_FILES=$(shell find . -path "./test/*.py")
MAIN_FILE=src/main.py
SOURCES_FOLDER=src
TESTS_FOLDER=tests

BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

check_no_main:
ifeq ($(BRANCH),main)
	echo "You are good to go!"
else
	$(error You are not in the main branch)
endif

patch: check_no_main
	$(POETRY) bumpversion patch --verbose
	git push --follow-tags

minor: check_no_main
	$(POETRY) bumpversion minor --verbose
	git push --follow-tags

major: check_no_main
	$(POETRY) bumpversion major --verbose
	git push --follow-tags

style:
	$(POETRY) isort $(SOURCES_FOLDER)
	$(POETRY) isort $(TESTS_FOLDER)
	$(POETRY) black $(SOURCES_FOLDER)
	$(POETRY) black $(TESTS_FOLDER)

lint:
	$(POETRY) isort $(SOURCES_FOLDER) --check-only
	$(POETRY) isort $(TESTS_FOLDER) --check-only
	$(POETRY) black $(SOURCES_FOLDER) --check
	$(POETRY) black $(TESTS_FOLDER) --check

tests:
	PYTHONPATH=. $(POETRY) pytest -vv test

run:
	$(POETRY) $(FLET) $(MAIN_FILE)