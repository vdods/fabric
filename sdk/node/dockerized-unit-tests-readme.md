## Dockerized Unit Tests for HFC

The files `docker-compose-*.yml` contain service definitions for running the HFC unit tests
within dockerized environments, in which everything is clean and controlled, closer to that
of a production environment.

### How To Run

Simply run `make dockerized-unit-tests`.  For each set of unit tests (e.g. registrar-test.js,
asset-mgmt.js, etc.), this should:

-   Spin up the necessary docker-compose services and run the specified unit test.
-   Detect when the unit test ends.
-   Store unit test's return code.
-   Bring the docker-compose services down.
-   Delete the (non-build) state (in particular, the peer's ledger state, the membersrvc state, and web server's
    key-value store).
-   Return the return code.

### Todos and Notes

-   TODO: Clean up the docker-compose files (using layering) and to move them into the test/fixtures
    directory, so they're not clogging up the hfc root dir.
-   TODO: Separate out the state for the peer and membersrvc into two separate volumes to simulate them
    actually being on separate machines.
-   TODO: Correct use of certificates -- right now, the `tlsca.cert` made by membersrvc is used for the
    peer as well.  Worse, that cert is read by the peer directly from the membersrvc's volume, which would
    not be possible in a real world situation.
