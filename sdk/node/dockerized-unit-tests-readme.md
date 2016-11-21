## Dockerized Unit Tests for HFC

The files `docker-compose-*.yml` contain service definitions for running the HFC unit tests
within dockerized environments, in which everything is clean and controlled, closer to that
of a production environment.

### How To Run

I'm not yet sure how to stop all docker services from within a docker-compose environment,
so unfortunately there is a bit of manual work required.  In particular, watching for the
result of the each unit test (run within the unittest_1 container).  Once this container
exists, the unit test is done, and the result can be seen, such as

    unittest_1        | 1..16
    unittest_1        | # tests 16
    unittest_1        | # pass  16
    unittest_1        |
    unittest_1        | # ok
    unittest_1        |
    node_unittest_1 exited with code 0

If the unit test didn't pass, there would be some number of failures, and it would be marked `not ok`.

#### The particulars of running the tests are as follows

1. Start the `registrar` test

        docker-compose -f docker-compose-registrar.yml up

2. Wait for node_unittest_1 to exit, observing the result, then hit `Ctrl+C`.  Make sure to bring the
services down (this deletes leftover containers, networks, etc, but leaves the volumes intact).

        docker-compose -f docker-compose-registrar.yml down

3. There should be 4 volumes at this point (`docker volume ls` will show 4 entries with the prefix `node_`).
Delete the persistent state that should be reset between unit tests.  The volumes `node_ccenv_devmode0_gopath`
and `node_unittest_node_modules` should be kept around because they contain build artifacts that would need
to be generated the same way upon each `up`.  The volumes `node_unittest_tmp` and `node_var_hyperledger_production`
should be deleted so they can start fresh with each unit test run.

        docker volume rm node_unittest_tmp node_var_hyperledger_production

The whole test procedure is to run steps 1 through 3 for each of the tests, listed in order of increasing
complexity.

    docker-compose-registrar.yml
    docker-compose-member-api.yml
    docker-compose-chain-tests.yml
    docker-compose-asset-mgmt.yml
    docker-compose-asset-mgmt-with-roles.yml
    docker-compose-asset-mgmt-with-dynamic-roles.yml
    docker-compose-event-tests.yml

### Todos and Notes

-   The main thing to do is have the finishing of each unit test bring the other services down, and exit
    docker-compose with the return status of the unit test, so that a string of docker and docker-compose
    commands can be used to run the entire unit test procedure and get a single return status value.
