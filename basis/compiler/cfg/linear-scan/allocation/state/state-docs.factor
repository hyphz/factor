USING: assocs compiler.cfg compiler.cfg.instructions
compiler.cfg.linear-scan.allocation compiler.cfg.linear-scan.live-intervals
cpu.architecture heaps help.markup help.syntax math sequences vectors ;
IN: compiler.cfg.linear-scan.allocation.state

HELP: active-intervals
{ $var-description { $link assoc } " of active live intervals. The keys are register class symbols and the values vectors of " { $link live-interval-state } "." } ;

HELP: handled-intervals
{ $var-description { $link vector } " of handled live intervals." } ;

HELP: unhandled-min-heap
{ $var-description { $link min-heap } " of all live intervals and sync points which still needs processing. It is used by " { $link (allocate-registers) } ". The key of the heap is a pair of values, " { $slot "start" } " and " { $slot "end" } " for the "  { $link live-interval-state } " tuple and " { $slot "n" } " and 1/0.0 for the " { $link sync-point } " tuple. That way smaller live intervals are always processed before larger ones and all live intervals before sync points." } ;

HELP: init-allocator
{ $values
  { "live-intervals" { $link sequence } " of " { $link live-interval-state } }
  { "sync-points" { $link sequence } " of " { $link sync-point } }
  { "registers" { $link assoc } " mapping from register class to available machine registers." }
}
{ $description "Initializes the state for the register allocator." }
{ $see-also reg-class } ;

HELP: next-spill-slot
{ $values { "size" "number of bytes required" } { "spill-slot" spill-slot } }
{ $description "Creates a new " { $link spill-slot } " of the given size and also allocates space in the " { $link cfg } " in the 'cfg' dynamic variable for it." } ;

HELP: spill-slots
{ $var-description "Mapping from vregs to spill slots." } ;

HELP: align-spill-area
{ $values { "align" integer } }
{ $description "This word is used to ensure that the alignment of the spill area in the " { $link cfg } " is equal to the largest " { $link spill-slot } "." } ;
