USING: help.markup help.syntax kernel quotations
deques search-deques hashtables ;
IN: dlists

ARTICLE: "dlists" "Double-linked lists"
"A double-linked list is the canonical implementation of a " { $link deque } "."
$nl
"Double-linked lists form a class:"
{ $subsections
    dlist
    dlist?
}
"Constructing a double-linked list:"
{ $subsections <dlist> }
"Double-linked lists support all the operations of the deque protocol (" { $link "deques" } ") as well as the following."
$nl
"Iterating over elements:"
{ $subsections
    dlist-each
    dlist-find
    dlist-filter
    dlist-any?
}
"Deleting a node matching a predicate:"
{ $subsections
    delete-node-if*
    delete-node-if
}
"Search deque implementation:"
{ $subsections <hashed-dlist> } ;

ABOUT: "dlists"

HELP: <dlist>
{ $values { "list" dlist } }
{ $description "Creates a new double-linked list." } ;

HELP: <hashed-dlist>
{ $values { "search-deque" search-deque } }
{ $description "Creates a new " { $link search-deque } " backed by a " { $link dlist } ", with a " { $link hashtable } " for fast membership tests." } ;

HELP: dlist-find
{ $values { "dlist" { $link dlist } } { "quot" quotation } { "obj/f" "an object or " { $link f } } { "?" boolean } }
{ $description "Applies the quotation to each element of the " { $link dlist } " in turn, until it outputs a true value or the end of the " { $link dlist } " is reached.  Outputs either the object it found or " { $link f } ", and a boolean which is true if an object is found." }
{ $notes "Returns a boolean to allow dlists to store " { $link f } "."
    $nl
    "This operation is O(n)."
} ;

HELP: dlist-filter
{ $values { "dlist" { $link dlist } } { "quot" quotation } { "dlist'" { $link dlist } } }
{ $description "Applies the quotation to each element of the " { $link dlist } " in turn, removing the corresponding nodes if the quotation returns " { $link f } "." }
{ $side-effects { "dlist" } } ;

HELP: dlist-any?
{ $values { "dlist" { $link dlist } } { "quot" quotation } { "?" boolean } }
{ $description "Just like " { $link dlist-find } " except it doesn't return the object." }
{ $notes "This operation is O(n)." } ;

HELP: delete-node-if*
{ $values { "dlist" { $link dlist } } { "quot" quotation } { "obj/f" "an object or " { $link f } } { "?" boolean } }
{ $description "Calls " { $link dlist-find } " on the " { $link dlist } " and deletes the node returned, if any.  Returns the value of the deleted node and a boolean to allow the deleted value to distinguished from " { $link f } ", for nothing deleted." }
{ $notes "This operation is O(n)." } ;

HELP: delete-node-if
{ $values { "dlist" { $link dlist } } { "quot" quotation } { "obj/f" "an object or " { $link f } } }
{ $description "Like " { $link delete-node-if* } " but cannot distinguish from deleting a node whose value is " { $link f } " or not deleting an element." }
{ $notes "This operation is O(n)." } ;

HELP: dlist-each
{ $values { "dlist" { $link dlist } } { "quot" quotation } }
{ $description "Iterate a " { $link dlist } ", calling quot on each element." } ;
