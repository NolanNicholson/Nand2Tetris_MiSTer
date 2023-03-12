// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// Include common routines
#include <verilated.h>

#define NUM_TESTS 4

// Include model header, generated from Verilating "top.v"
#include "Vtop.h"

int main(int argc, char** argv, char** env) {
    // Prevent unused variable warnings
    if (false && argc && argv && env) {}

    VerilatedContext* contextp = new VerilatedContext;
    Vtop* top = new Vtop{contextp};

    int values_a[] = { 0, 1, 0, 1 };
    int values_b[] = { 0, 0, 1, 1 };
    int values_out_nand[] = { 1, 1, 1, 0 };

    for (int i = 0; i < NUM_TESTS; i++)
    {
        top->in_a = values_a[i];
        top->in_b = values_b[i];
        top->eval();

        if (top->out_nand != values_out_nand[i])
        {
            VL_PRINTF("Nand gate failed test: a = %d, b = %d, out = %d (expected %d)\n",
                    top->in_a, top->in_b, top->out_nand, values_out_nand[i]);
        }
    }

    VL_PRINTF("Test complete!\n");

    top->final();
    delete top;
    delete contextp;
    return 0;
}
