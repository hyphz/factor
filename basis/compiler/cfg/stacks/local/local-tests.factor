USING: accessors assocs biassocs combinators compiler.cfg.instructions
compiler.cfg.registers compiler.cfg.stacks.local cpu.architecture kernel
namespaces sequences tools.test ;
IN: compiler.cfg.stacks.local.tests

{ T{ current-height f 3 0 3 0 } } [
    current-height new current-height [
        3 inc-d current-height get
    ] with-variable
] unit-test

{
    { T{ ##inc-d { n 4 } } T{ ##inc-r { n -2 } } }
} [
    T{ current-height { emit-d 4 } { emit-r -2 } } height-changes
] unit-test

{ 30 } [
    29 vreg-counter set-global <bihash> locs>vregs set D 0 loc>vreg
] unit-test

{
    {
        T{ ##copy { dst 1 } { src 25 } { rep any-rep } }
        T{ ##copy { dst 2 } { src 26 } { rep any-rep } }
    }
} [
    0 vreg-counter set-global <bihash> locs>vregs set
    { { D 0 25 } { R 0 26 } } stack-changes
] unit-test

{ 80 } [
    current-height new current-height set
    H{ } clone replace-mapping set 80
    D 77 replace-loc D 77 peek-loc
] unit-test
