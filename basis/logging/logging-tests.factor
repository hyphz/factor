IN: logging.tests
USING: tools.test logging logging.analysis logging.server io
io.files.temp math ;

: input-logging-test ( a b -- c ) + ;

\ input-logging-test NOTICE add-input-logging

: output-logging-test ( a b -- c ) + ;

\ output-logging-test DEBUG add-output-logging

: error-logging-test ( a b -- c ) / ;

\ error-logging-test ERROR add-error-logging

temp-directory [
    "logging-test" [
        [ 4 ] [ 1 3 input-logging-test ] unit-test

        [ 4 ] [ 1 3 output-logging-test ] unit-test

        [ 4/3 ] [ 4 3 error-logging-test ] unit-test

        [ f ] [ 1 0 error-logging-test ] unit-test
    ] with-logging

    [ ] [ "logging-test" { "input-logging-test" } analyze-log-file ] unit-test
] with-log-root
