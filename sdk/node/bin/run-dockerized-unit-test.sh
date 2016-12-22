#!/bin/bash -x

# Run the test, quitting when one of the services (unittest) goes down.
docker-compose -f ${1} up --abort-on-container-exit
# Retrieve the unit test service name (should be something like node_unittest_1, but doesn't have to be)
UNITTEST_SERVICE_NAME=$(docker-compose -f ${1} ps | grep -o "[^ \t]*_unittest_[^ \t]*")
# Retrieve the return code (see http://blog.ministryofprogramming.com/docker-compose-and-exit-codes/ )
UNITTEST_RETURN_CODE=$(docker inspect -f '{{ .State.ExitCode }}' ${UNITTEST_SERVICE_NAME})
# Bring the services down
docker-compose -f ${1} down
# Delete the (non-build/dependency) state accumulated during the test
docker volume rm node_unittest_tmp node_var_hyperledger_production
# Return using the test's return code.
exit ${UNITTEST_RETURN_CODE}
