
TESTS=tests/*.js
MONGO_CONNECTION?=mongodb://localhost/test_db
CUSTOMCONNSTR_mongo_settings_collection?=test_settings
CUSTOMCONNSTR_mongo_collection?=test_sgvs
MONGO_SETTINGS=MONGO_CONNECTION=${MONGO_CONNECTION} \
	CUSTOMCONNSTR_mongo_collection=${CUSTOMCONNSTR_mongo_collection} \
	CUSTOMCONNSTR_mongo_settings_collection=${CUSTOMCONNSTR_mongo_settings_collection}

MOCHA=$(shell which mocha ./node_modules/mocha/bin/_mocha)

.PHONY: all coverage test travis report

all: test

coverage:
	NODE_ENV=test ${MONGO_SETTINGS} \
	istanbul cover ${MOCHA} -- -vvv -R tap ${TESTS}

test:
	${MONGO_SETTINGS} ${MOCHA} --verbose -vvv -R tap ${TESTS}

report:
	npm install coveralls && cat ./coverage/lcov.info | ./node_modules/.bin/coveralls

travis:
	NODE_ENV=test ${MONGO_SETTINGS} \
	istanbul cover ${MOCHA} --report lcovonly -- -vvv -R tap ${TESTS}
