// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0
//======================================================================

// Include common routines
#include <verilated.h>
#include <stdio.h>

// Include model header, generated from Verilating "top.v"
#include "Vtop.h"

int num_pass = 0;
int num_fail = 0;
char test_desc[256];

void assert_equal(int out, int expected, const char *desc)
{
    if (out == expected)
    {
        num_pass++;
    }
    else
    {
        VL_PRINTF("  Test failed on %s! Got %d, expected %d\n",
                desc, out, expected);
        num_fail++;
    }
}

int main(int argc, char** argv, char** env) {
    // Prevent unused variable warnings
    if (false && argc && argv && env) {}

    VerilatedContext* contextp = new VerilatedContext;
    Vtop* top = new Vtop{contextp};

    uint16_t expected;

    int a, b, c;

    // Half-Adder
    for (int i = 0; i < 4; i++)
    {
        a = i & 0x01;
        b = (i & 0x02) >> 1;

        top->in_a = a;
        top->in_b = b;
        top->eval();

        sprintf(test_desc, "Half-Adder Sum (a=%d, b=%d)", a, b);
        assert_equal(top->out_ha_sum, (a + b) & 0x01, test_desc);
        sprintf(test_desc, "Half-Adder carry (a=%d, b=%d)", a, b);
        assert_equal(top->out_ha_carry, ((a + b) & 0x02) >> 1, test_desc);
    }

    assert_equal(0, 1, "(Unwritten tests)");

    VL_PRINTF("Test results: %d pass, %d fail\n", num_pass, num_fail);

    top->final();
    delete top;
    delete contextp;
    return 0;
}
