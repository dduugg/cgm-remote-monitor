
TESTS=tests/*.js
MONGO_CONNECTION?=mongodb://localhost/test_db
CUSTOMCONNSTR_mongo_settings_collection?=test_settings
CUSTOMCONNSTR_mongo_collection?=test_sgvs
MONGO_SETTINGS=MONGO_CONNECTION=${MONGO_CONNECTION} \
    CUSTOMCONNSTR_mongo_collection=${CUSTOMCONNSTR_mongo_collection} \
    CUSTOMCONNSTR_mongo_settings_collection=${CUSTOMCONNSTR_mongo_settings_collection}

all: test

travis:
    NODE_ENV=test \
    ${MONGO_SETTINGS} \
    istanbul cover ./node_modules/mocha/bin/_mocha --report lcovonly -- -vvv -R tap ${TESTS}

test:
    ${MONGO_SETTINGS} \
    mocha --verbose -vvv -R tap ${TESTS}

.PHONY: test
