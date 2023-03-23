// Nand to Tetris: Chapter 2 testbench

// For reading files and lines
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

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
        VL_PRINTF("  Test failed on %s! Got %#x, expected %#x\n",
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

    // Full-Adder
    const uint8_t fulladder_a[] = { 0, 0, 0, 0, 1, 1, 1, 1 };
    const uint8_t fulladder_b[] = { 0, 0, 1, 1, 0, 0, 1, 1 };
    const uint8_t fulladder_c[] = { 0, 1, 0, 1, 0, 1, 0, 1 };
    const uint8_t fulladder_sum[] = { 0, 1, 1, 0, 1, 0, 0, 1 };
    const uint8_t fulladder_carry[] = { 0, 0, 0, 1, 0, 1, 1, 1 };

    for (int i = 0; i < 8; i++)
    {
        top->in_a = fulladder_a[i];
        top->in_b = fulladder_b[i];
        top->in_c = fulladder_c[i];
        top->eval();

        sprintf(test_desc, "Full-Adder Sum (a=%d, b=%d, c=%d)", top->in_a, top->in_b, top->in_c);
        assert_equal(top->out_fa_sum, fulladder_sum[i], test_desc);
        sprintf(test_desc, "Full-Adder carry (a=%d, b=%d, c=%d)", top->in_a, top->in_b, top->in_c);
        assert_equal(top->out_fa_carry, fulladder_carry[i], test_desc);
    }

    // Add16
    const uint16_t add16_a[]   = { 0x0000, 0x0000, 0xFFFF, 0xAAAA, 0x3CC3, 0x1234 };
    const uint16_t add16_b[]   = { 0x0000, 0xFFFF, 0xFFFF, 0x5555, 0x0FF0, 0x9876 };
    const uint16_t add16_out[] = { 0x0000, 0xFFFF, 0xFFFE, 0xFFFF, 0x4CB3, 0xAAAA };
    
    for (int i = 0; i < 6; i++)
    {
        top->in16_a = add16_a[i];
        top->in16_b = add16_b[i];
        top->eval();

        sprintf(test_desc, "Add16 Sum (a=%#x, b=%#x)", top->in16_a, top->in16_b);
        assert_equal(top->out16_sum, add16_out[i], test_desc);
    }

    // Inc16
    const uint16_t inc_in[] = { 0x0000, 0xFFFF, 0x0005, 0xFFFB };

    for (int i = 0; i < 4; i++)
    {
        top->in16_a = inc_in[i];
        top->eval();

        sprintf(test_desc, "Inc16 (in=%#x)", top->in16_a);
        assert_equal(top->out16_inc, (inc_in[i] + 0x0001) & 0xFFFF, test_desc);
    }

    // ALU (no flags)
    /*
    |        x         |        y         |zx |nx |zy |ny | f |no |       out        |
    | 0000000000000000 | 1111111111111111 | 1 | 0 | 1 | 0 | 1 | 0 | 0000000000000000 |
    */

    std::string line;
    std::stringstream line_ss;
    std::string token;
    std::ifstream cmp_file;
    cmp_file.open("cmp/ALU-nostat.cmp");
    if (cmp_file.is_open())
    {
        getline(cmp_file, line); // chew through first line
        while(getline(cmp_file, line))
        {
            line_ss.str(line);
            getline(line_ss, token, '|'); // discard initial delimiter

            getline(line_ss, token, '|'); // get X
            top->in16_x = std::stol(token, nullptr, 2);

            getline(line_ss, token, '|'); // get Y
            top->in16_y = std::stol(token, nullptr, 2);

            getline(line_ss, token, '|'); // get ZX
            top->in_zx = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get NX
            top->in_nx = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get ZY
            top->in_zy = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get NY
            top->in_ny = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get F
            top->in_f = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get NO
            top->in_no = std::stoi(token, nullptr);

            // all inputs received
            top->eval();

            getline(line_ss, token, '|'); // get OUT
            expected = std::stol(token, nullptr, 2);

            sprintf(test_desc,
                    "ALU-NoStat (x=%#x, y=%#x, zx=%d, nx=%d, zy=%d, ny=%d, f=%d, no=%d)",
                    top->in16_x, top->in16_y,
                    top->in_zx, top->in_nx,
                    top->in_zy, top->in_ny,
                    top->in_f, top->in_no);
            assert_equal(top->out16_alu, expected, test_desc);
            
        }

        cmp_file.close();
    }
    else
    {
        std::cerr << "Error: CMP file not found" << std::endl;
    }

    // ALU (with flags)
    /*
    |        x         |        y         |zx |nx |zy |ny | f |no |       out        |zr |ng |
    | 0000000000000000 | 1111111111111111 | 1 | 0 | 1 | 0 | 1 | 0 | 0000000000000000 | 1 | 0 |
    | 0000000000000000 | 1111111111111111 | 1 | 1 | 1 | 1 | 1 | 1 | 0000000000000001 | 0 | 0 |
     */

    cmp_file.open("cmp/ALU.cmp");
    if (cmp_file.is_open())
    {
        getline(cmp_file, line); // chew through first line
        while(getline(cmp_file, line))
        {
            line_ss.str(line);
            getline(line_ss, token, '|'); // discard initial delimiter

            getline(line_ss, token, '|'); // get X
            top->in16_x = std::stol(token, nullptr, 2);

            getline(line_ss, token, '|'); // get Y
            top->in16_y = std::stol(token, nullptr, 2);

            getline(line_ss, token, '|'); // get ZX
            top->in_zx = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get NX
            top->in_nx = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get ZY
            top->in_zy = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get NY
            top->in_ny = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get F
            top->in_f = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get NO
            top->in_no = std::stoi(token, nullptr);

            // all inputs received
            top->eval();

            getline(line_ss, token, '|'); // get OUT
            expected = std::stol(token, nullptr, 2);

            sprintf(test_desc,
                    "ALU OUT (x=%#x, y=%#x, zx=%d, nx=%d, zy=%d, ny=%d, f=%d, no=%d)",
                    top->in16_x, top->in16_y,
                    top->in_zx, top->in_nx,
                    top->in_zy, top->in_ny,
                    top->in_f, top->in_no);
            assert_equal(top->out16_alu, expected, test_desc);

            getline(line_ss, token, '|'); // get ZR
            expected = std::stoi(token, nullptr);

            sprintf(test_desc,
                    "ALU ZR (x=%#x, y=%#x, zx=%d, nx=%d, zy=%d, ny=%d, f=%d, no=%d)",
                    top->in16_x, top->in16_y,
                    top->in_zx, top->in_nx,
                    top->in_zy, top->in_ny,
                    top->in_f, top->in_no);
            assert_equal(top->out_zr, expected, test_desc);

            getline(line_ss, token, '|'); // get NG
            expected = std::stoi(token, nullptr);

            sprintf(test_desc,
                    "ALU NG (x=%#x, y=%#x, zx=%d, nx=%d, zy=%d, ny=%d, f=%d, no=%d)",
                    top->in16_x, top->in16_y,
                    top->in_zx, top->in_nx,
                    top->in_zy, top->in_ny,
                    top->in_f, top->in_no);
            assert_equal(top->out_ng, expected, test_desc);
            
        }

        cmp_file.close();
    }
    else
    {
        std::cerr << "Error: CMP file not found" << std::endl;
    }

    VL_PRINTF("Test results: %d pass, %d fail\n", num_pass, num_fail);

    top->final();
    delete top;
    delete contextp;
    return 0;
}
