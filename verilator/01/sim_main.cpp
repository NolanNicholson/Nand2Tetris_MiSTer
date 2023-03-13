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
    uint16_t expected;

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
        top->in_sel = (i >> 2) & 1;
        top->in_a = (i >> 1) & 1;
        top->in_b = i & 1;
        top->eval();

        sprintf(test_desc, "Mux (a=%d, b=%d, sel=%d)", top->in_a, top->in_b, top->in_sel);
        expected = top->in_sel ? top->in_b : top->in_a;
        assert_equal(top->out_mux, expected, test_desc);
    }

    // Test demultiplexer
    for (int i = 0; i < 4; i++)
    {
        top->in_a = i & 1;
        top->in_sel = (i >> 1) & 1;
        top->eval();

        sprintf(test_desc, "Dmux Output A (in=%d, sel=%d)", top->in_a, top->in_sel);
        expected = top->in_sel ? 0 : top->in_a;
        assert_equal(top->out_dmux_a, expected, test_desc);

        sprintf(test_desc, "Dmux Output B (in=%d, sel=%d)", top->in_a, top->in_sel);
        expected = top->in_sel ? top->in_a : 0;
        assert_equal(top->out_dmux_b, expected, test_desc);
    }

    uint16_t values_16[] = { 0, 0x1234, 0x8000, 0xFFFF };

    // test 16-bit unary operations
    for (int ia = 0; ia < 4; ia++)
    {
        top->in16_a = values_16[ia];
        top->eval();

        // Test Not16
        sprintf(test_desc, "Not16 (in=%d)", top->in16_a);
        expected = ~top->in16_a;
        assert_equal(top->out16_not, expected, test_desc);
    }

    // test 16-bit binary operations
    for (int ia = 0; ia < 4; ia++)
    {
        for (int ib = 0; ib < 4; ib++)
        {
            top->in16_a = values_16[ia];
            top->in16_b = values_16[ib];
            top->eval();

            // Test And16
            sprintf(test_desc, "AND16 gate (a=%d, b=%d)", top->in16_a, top->in16_b);
            expected = top->in16_a & top->in16_b;
            assert_equal(top->out16_and, expected, test_desc);

            // Test Or16
            sprintf(test_desc, "OR16 gate (a=%d, b=%d)", top->in16_a, top->in16_b);
            expected = top->in16_a | top->in16_b;
            assert_equal(top->out16_or, expected, test_desc);

            // Test Mux16
            for (int sel = 0; sel < 2; sel++)
            {
                top->in_sel = sel;
                top->eval();

                sprintf(test_desc, "MUX16 gate (a=%d, b=%d, sel=%d)", top->in16_a, top->in16_b, top->in_sel);
                expected = sel ? top->in16_b : top->in16_a;
                assert_equal(top->out16_mux, expected, test_desc);
            }
        }
    }
    
    // Test Or8Way
    uint8_t inputs_or8way[] = { 0x00, 0xFF, 0x37, 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };
    for (int i = 0; i < 5; i++)
    {
        top->in8_a = inputs_or8way[i];
        top->eval();

        sprintf(test_desc, "8way OR gate (in=%d)", top->in8_a);
        expected = top->in8_a > 0;
        assert_equal(top->out_or8way, expected, test_desc);
    }

    uint16_t mux16_inputs[] = { 0x0000, 0xFFFF, 0x0234, 0xBEEF, 0x0010, 0x0002, 0x6502, 0x2A03};
    for (int ia = 0; ia < 4; ia++)
    {
        top->in16_a = mux16_inputs[ia];

        for (int ib = 0; ib < 4; ib++)
        {
            top->in16_b = mux16_inputs[ib];

            for (int ic = 0; ic < 4; ic++)
            {
                top->in16_c = mux16_inputs[ic];

                for (int id=0; id < 4; id++)
                {
                    top->in16_d = mux16_inputs[id];

                    for (int sel = 0; sel < 4; sel++)
                    {
                        top->in2_sel = sel;
                        top->eval();

                        // Test Mux4Way16
                        sprintf(test_desc, "Mux4Way16 (a=%d, b=%d, c=%d, d=%d, sel=%d)",
                                top->in16_a, top->in16_b, top->in16_c, top->in16_d, top->in2_sel);
                        switch (sel)
                        {
                            case 0: expected = top->in16_a; break;
                            case 1: expected = top->in16_b; break;
                            case 2: expected = top->in16_c; break;
                            case 3: expected = top->in16_d; break;
                        }
                        assert_equal(top->out16_mux4, expected, test_desc);
                    }
                }
            }
        }
    }

    for (int i = 0; i < 8; i++)
    {
        top->in16_a = mux16_inputs[(0 + i) % 8];
        top->in16_b = mux16_inputs[(1 + i) % 8];
        top->in16_c = mux16_inputs[(2 + i) % 8];
        top->in16_d = mux16_inputs[(3 + i) % 8];
        top->in16_e = mux16_inputs[(4 + i) % 8];
        top->in16_f = mux16_inputs[(5 + i) % 8];
        top->in16_g = mux16_inputs[(6 + i) % 8];
        top->in16_h = mux16_inputs[(7 + i) % 8];

        for (int sel = 0; sel < 8; sel++)
        {
            top->in3_sel = sel;
            top->eval();

            // Test Mux8Way16 TODO
            sprintf(test_desc, "Mux8Way16 (a=%d, b=%d, c=%d, d=%d, e=%d, f=%d, g=%d, h=%d  ;  sel=%d)",
                    top->in16_a, top->in16_b, top->in16_c, top->in16_d, top->in16_e, top->in16_f, top->in16_g, top->in16_h, top->in3_sel);
            switch(sel)
            {
                case 0: expected = top->in16_a; break;
                case 1: expected = top->in16_b; break;
                case 2: expected = top->in16_c; break;
                case 3: expected = top->in16_d; break;
                case 4: expected = top->in16_e; break;
                case 5: expected = top->in16_f; break;
                case 6: expected = top->in16_g; break;
                case 7: expected = top->in16_h; break;
            }
            assert_equal(top->out16_mux8, expected, test_desc);
        }
    }

    // Test DMux4Way
    for (int sel = 0; sel < 4; sel++)
    {
        top->in2_sel = sel;

        for (int in = 0; in < 2; in++)
        {
            top->in_a = in;
            top->eval();

            int results[4] = { top->out_dmux4_a, top->out_dmux4_b, top->out_dmux4_c, top->out_dmux4_d };
            
            for (int i_result = 0; i_result < 4; i_result++)
            {
                sprintf(test_desc, "DMux4Way (in=%d, sel=%d, out-index=%d)", top->in_a, top->in2_sel, i_result);
                expected = i_result == sel ? in : 0;
                assert_equal(results[i_result], expected, test_desc);
            }
        }
    }

    // Test DMux8Way
    for (int sel = 0; sel < 8; sel++)
    {
        top->in3_sel = sel;

        for (int in = 0; in < 2; in++)
        {
            top->in_a = in;
            top->eval();

            int results[8] = {
                top->out_dmux8_a, top->out_dmux8_b, top->out_dmux8_c, top->out_dmux8_d,
                top->out_dmux8_e, top->out_dmux8_f, top->out_dmux8_g, top->out_dmux8_h };
            
            for (int i_result = 0; i_result < 8; i_result++)
            {
                sprintf(test_desc, "DMux8Way (in=%d, sel=%d, out-index=%d)", top->in_a, top->in3_sel, i_result);
                expected = i_result == sel ? in : 0;
                assert_equal(results[i_result], expected, test_desc);
            }
        }
    }


    VL_PRINTF("Test results: %d pass, %d fail\n", num_pass, num_fail);

    top->final();
    delete top;
    delete contextp;
    return 0;
}
