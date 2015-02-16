
# Nightscout tests/builds/analysis
TESTS=tests/*.js
MONGO_CONNECTION?=mongodb://localhost/test_db
CUSTOMCONNSTR_mongo_settings_collection?=test_settings
CUSTOMCONNSTR_mongo_collection?=test_sgvs
MONGO_SETTINGS=MONGO_CONNECTION=${MONGO_CONNECTION} \
	CUSTOMCONNSTR_mongo_collection=${CUSTOMCONNSTR_mongo_collection} \
	CUSTOMCONNSTR_mongo_settings_collection=${CUSTOMCONNSTR_mongo_settings_collection}

# XXX.bewest: Mocha is an odd process, and since things are being
# wrapped and transformed, this odd path needs to be used, not the
# normal wrapper.  When ./node_modules/.bin/mocha is used, no coverage
# information is generated.  This happens because typical shell
# wrapper performs process management that mucks with the test
# coverage reporter's ability to instrument the tests correctly.
# Hard coding it to the local with our pinned version is bigger for
# initial installs, but ensures a consistent environment everywhere.
MOCHA=./node_modules/mocha/bin/_mocha
ISTANBUL=$(shell which istanbul ./node_modules/.bin/istanbul | head -n 1)

.PHONY: all coverage report test travis

all: test

coverage:
	NODE_ENV=test ${MONGO_SETTINGS} \
	${ISTANBUL} cover ${MOCHA} -- -R tap ${TESTS}

report:
	test -f ./coverage/lcov.info && (npm install coveralls && cat ./coverage/lcov.info | ./node_modules/.bin/coveralls) || echo "NO COVERAGE"

test:
	${MONGO_SETTINGS} ${MOCHA} -R tap ${TESTS}

travis:
	NODE_ENV=test ${MONGO_SETTINGS} \
	${ISTANBUL} cover ${MOCHA} --report lcovonly -- -R tap ${TESTS}
