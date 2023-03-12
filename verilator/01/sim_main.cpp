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

    int values_a[] =        { 0, 1, 0, 1 };
    int values_b[] =        { 0, 0, 1, 1 };
    int expected;

    // Test binary logic gates
    for (int i = 0; i < 4; i++)
    {
        top->in_a = values_a[i];
        top->in_b = values_b[i];
        top->eval();

        sprintf(test_desc, "NAND gate (a=%d, b=%d)", top->in_a, top->in_b);
        expected = !(top->in_a && top->in_b);
        assert_equal(top->out_nand, expected, test_desc);

        sprintf(test_desc, "AND gate (a=%d, b=%d)", top->in_a, top->in_b);
        expected = top->in_a && top->in_b;
        assert_equal(top->out_and, expected, test_desc);

        sprintf(test_desc, "OR gate (a=%d, b=%d)", top->in_a, top->in_b);
        expected = top->in_a || top->in_b;
        assert_equal(top->out_or, expected, test_desc);

        sprintf(test_desc, "XOR gate (a=%d, b=%d)", top->in_a, top->in_b);
        expected = top->in_a ^ top->in_b;
        assert_equal(top->out_xor, expected, test_desc);
    }

    // Test unary NOT gate
    for (int i = 0; i < 2; i++)
    {
        top->in_a = values_a[i];
        top->eval();

        sprintf(test_desc, "NOT gate (a=%d)", top->in_a);
        expected = !top->in_a;
        assert_equal(top->out_not, expected, test_desc);
    }

    // Test multiplexer
    for (int i = 0; i < 8; i++)
    {
        top->in_sel = (i >> 2);
        top->in_a = (i >> 1) & 1;
        top->in_b = i & 1;

        sprintf(test_desc, "Mux (a=%d, b=%d, sel=%d)", top->in_a, top->in_b, top->in_sel);
        expected = top->in_sel ? top->in_b : top->in_a;
        assert_equal(top->out_mux, expected, test_desc);
    }

    // Test demultiplexer
    for (int i = 0; i < 4; i++)
    {
        top->in_a = i & 1;
        top->in_sel = (i >> 1) & 1;

        sprintf(test_desc, "Dmux Output A (in=%d, sel=%d)", top->in_a, top->in_sel);
        expected = top->in_sel ? 0 : top->in_a;
        assert_equal(top->out_dmux_a, expected, test_desc);

        sprintf(test_desc, "Dmux Output B (in=%d, sel=%d)", top->in_a, top->in_sel);
        expected = top->in_sel ? top->in_a : 0;
        assert_equal(top->out_dmux_b, expected, test_desc);
    }

    // Test Not16 TODO
    // Test And16 TODO
    // Test Or16 TODO
    // Test Mux16 TODO
    // Test Or8Way TODO
    // Test Mux4Way16 TODO
    // Test Mux8Way16 TODO
    // Test DMux4Way TODO
    // Test DMux8Way TODO
    
    sprintf(test_desc, "Unwritten Tests");
    assert_equal(0, 1, test_desc);



    VL_PRINTF("Test results: %d pass, %d fail\n", num_pass, num_fail);

    top->final();
    delete top;
    delete contextp;
    return 0;
}
