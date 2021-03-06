! Copyright (C) 2008 Peter Burns, 2009 Philipp Winkler
! See http://factorcode.org/license.txt for BSD license.

USING: arrays assocs combinators fry hashtables io
io.streams.string json kernel kernel.private math math.parser
namespaces sbufs sequences sequences.private strings vectors ;

IN: json.reader

<PRIVATE

: json-number ( char stream -- num char )
    [ 1string ] [ "\s\t\r\n,:}]" swap stream-read-until ] bi*
    [ append string>number ] dip ;

DEFER: (read-json-string)

: (read-json-escape) ( stream accum -- accum )
    { sbuf } declare
    over stream-read1 {
        { CHAR: " [ CHAR: " ] }
        { CHAR: \\ [ CHAR: \\ ] }
        { CHAR: / [ CHAR: / ] }
        { CHAR: b [ CHAR: \b ] }
        { CHAR: f [ CHAR: \f ] }
        { CHAR: n [ CHAR: \n ] }
        { CHAR: r [ CHAR: \r ] }
        { CHAR: t [ CHAR: \t ] }
        { CHAR: u [ 4 pick stream-read hex> ] }
        [ ]
    } case [ suffix! (read-json-string) ] [ json-error ] if* ;

: (read-json-string) ( stream accum -- accum )
    { sbuf } declare
    "\\\"" pick stream-read-until [ append! ] dip
    CHAR: \" = [ nip ] [ (read-json-escape) ] if ;

: read-json-string ( stream -- str )
    "\\\"" over stream-read-until CHAR: \" =
    [ nip ] [ >sbuf (read-json-escape) { sbuf } declare "" like ] if ;

: second-last-unsafe ( seq -- second-last )
    [ length 2 - ] [ nth-unsafe ] bi ; inline

: pop-unsafe ( seq -- elt )
    [ length 1 - ] keep [ nth-unsafe ] [ shorten ] 2bi ; inline

: check-length ( seq n -- seq )
    [ dup length ] [ >= ] bi* [ json-error ] unless ; inline

: v-over-push ( accum -- accum )
    { vector } declare 2 check-length
    dup [ pop-unsafe ] [ last-unsafe ] bi
    { vector } declare push ;

: v-pick-push ( accum -- accum )
    { vector } declare 3 check-length dup
    [ pop-unsafe ] [ second-last-unsafe ] bi
    { vector } declare push ;

: v-pop ( accum -- vector )
    pop { vector } declare ; inline

: v-close ( accum -- accum )
    { vector } declare
    dup last V{ } = not [ v-over-push ] when
    { vector } declare ; inline

: json-open-array ( accum -- accum )
    { vector } declare V{ } clone suffix! ;

: json-open-hash ( accum -- accum )
    { vector } declare V{ } clone suffix! V{ } clone suffix! ;

: json-close-array ( accum -- accum )
    v-close dup v-pop { } like suffix! ;

: json-close-hash ( accum -- accum )
    v-close dup dup [ v-pop ] bi@ swap H{ } zip-as suffix! ;

: json-expect ( token stream -- )
    [ dup length ] [ stream-read ] bi* = [ json-error ] unless ; inline

: scan ( stream accum char -- stream accum )
    ! 2dup 1string swap . . ! Great for debug...
    { object vector object } declare
    {
        { CHAR: \" [ over read-json-string suffix! ] }
        { CHAR: [  [ json-open-array ] }
        { CHAR: ,  [ v-over-push ] }
        { CHAR: ]  [ json-close-array ] }
        { CHAR: {  [ json-open-hash ] }
        { CHAR: :  [ v-pick-push ] }
        { CHAR: }  [ json-close-hash ] }
        { CHAR: \s [ ] }
        { CHAR: \t [ ] }
        { CHAR: \r [ ] }
        { CHAR: \n [ ] }
        { CHAR: t  [ "rue" pick json-expect t suffix! ] }
        { CHAR: f  [ "alse" pick json-expect f suffix! ] }
        { CHAR: n  [ "ull" pick json-expect json-null suffix! ] }
        [ pick json-number [ suffix! ] dip [ scan ] when*  ]
    } case ;

: stream-json-read ( stream -- objects )
    V{ } clone over '[ _ stream-read1 dup ] [ scan ] while drop nip ;

PRIVATE>

: read-jsons ( -- objects )
    input-stream get stream-json-read ;

: json> ( string -- object )
    [ read-jsons first ] with-string-reader ;
