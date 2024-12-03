/*
 * Copyright (c) 2013-2020, ARM Limited and Contributors. All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef ASM_MACROS_REG_IO_S
#define ASM_MACROS_REG_IO_S

    /*
     * Helper macro to generate the best mov/movk combinations according
     * the value to be moved. The 16 bits from '_shift' are tested and
     * if not zero, they are moved into '_reg' without affecting
     * other bits.
     */
    .macro _mov_imm16 _reg, _val, _shift
        .if (\_val >> \_shift) & 0xffff
            .if (\_val & (1 << \_shift - 1))
                movk    \_reg, (\_val >> \_shift) & 0xffff, LSL \_shift
            .else
                mov    \_reg, \_val & (0xffff << \_shift)
            .endif
        .endif
    .endm

    /*
     * Helper macro to load arbitrary values into 32 or 64-bit registers
     * which generates the best mov/movk combinations. Many base addresses
     * are 64KB aligned the macro will eliminate updating bits 15:0 in
     * that case
     */
    .macro mov_imm _reg, _val
        .if (\_val) == 0
            mov    \_reg, #0
        .else
            _mov_imm16  \_reg, (\_val), 0
            _mov_imm16  \_reg, (\_val), 16
            _mov_imm16  \_reg, (\_val), 32
            _mov_imm16  \_reg, (\_val), 48
        .endif
    .endm

    /*
     * Helper macro to read system register value into x0
     */
    .macro read reg:req
    mrs    x0, \reg
    ret
    .endm

    /*
     * Helper macro to write value from x1 to system register
     */
    .macro write reg:req
    msr    \reg, x1
    ret
    .endm

#endif /* ASM_MACROS_REG_IO_S */
