// Nand to Tetris: Chapter 3 testbench

// For reading files and lines
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

// For std::unique_ptr
#include <memory>

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

    Verilated::mkdir("logs");

    const std::unique_ptr<VerilatedContext> contextp {new VerilatedContext};

    // Verilator must compute traced signals
    contextp->traceEverOn(true);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    contextp->commandArgs(argc, argv);

    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v".
    const std::unique_ptr<Vtop> top {new Vtop{contextp.get(), "TOP"}};

    std::string line;
    std::stringstream line_ss;
    std::string token;
    std::string time;
    std::ifstream cmp_file;

    uint16_t expected;


    // Bit
    /*
    | time | in  |load | out |
    | 0+   |  0  |  0  |  0  |
    | 1    |  0  |  0  |  0  |
    | 1+   |  0  |  1  |  0  |
    */
    cmp_file.open("cmp/Bit.cmp");
    top->clk = 1;
    if (cmp_file.is_open())
    {
        getline(cmp_file, line); // discard first line
        while(getline(cmp_file, line))
        {
            line_ss.str(line);
            getline(line_ss, token, '|'); // discard initial delimiter

            getline(line_ss, token, '|'); // get time, and update if needed
            if (token.compare(time) != 0)
            {
                contextp->timeInc(1);
                top->clk = !top->clk;
                time = token;
            }

            getline(line_ss, token, '|'); // get IN
            top->in = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get LOAD
            top->load = std::stoi(token, nullptr);

            // all inputs received
            top->eval();

            getline(line_ss, token, '|'); // get OUT
            expected = std::stoi(token, nullptr);

            sprintf(test_desc, "Bit @ time = %s", time.c_str());
            assert_equal(top->out_bit, expected, test_desc);
        }

        cmp_file.close();
    }
    else
    {
        std::cerr << "Error: CMP file not found" << std::endl;
    }

    assert_equal(0, 1, "Unwritten tests: Register (16-bit)");
    assert_equal(0, 1, "Unwritten tests: RAM8");
    assert_equal(0, 1, "Unwritten tests: RAM64");
    assert_equal(0, 1, "Unwritten tests: RAM512");
    assert_equal(0, 1, "Unwritten tests: RAM4K");
    assert_equal(0, 1, "Unwritten tests: RAM16K");

    VL_PRINTF("Test results: %d pass, %d fail\n", num_pass, num_fail);

    top->final();
    return 0;
}
