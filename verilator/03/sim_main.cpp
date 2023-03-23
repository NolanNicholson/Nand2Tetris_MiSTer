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

enum RAM_size { RAM8, RAM64, RAM512, RAM4K, RAM16K };

void run_RAM_tests(const char *filename,
        RAM_size ram_size,
        const std::unique_ptr<Vtop> &top,
        const std::unique_ptr<VerilatedContext> &contextp)
{
    std::string line;
    std::stringstream line_ss;
    std::string token;
    std::string time;
    std::ifstream cmp_file;
    uint16_t load;
    uint16_t got;
    uint16_t expected;

    std::string ram_name;
    switch (ram_size)
    {
        case RAM8: ram_name = "RAM8"; break;
        case RAM64: ram_name = "RAM16"; break;
        case RAM512: ram_name = "RAM512"; break;
        case RAM4K: ram_name = "RAM4K"; break;
        case RAM16K: ram_name = "RAM16K"; break;
    }

    cmp_file.open(filename);
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
            top->in16 = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get LOAD
            load = std::stoi(token, nullptr);
            switch (ram_size)
            {
                case RAM8: top->load_RAM8 = load; break;
                case RAM64: top->load_RAM64 = load; break;
                case RAM512: top->load_RAM512 = load; break;
                case RAM4K: top->load_RAM4K = load; break;
                case RAM16K: top->load_RAM16K = load; break;
            }

            getline(line_ss, token, '|'); // get ADDRESS
            top->address = std::stoi(token, nullptr);

            // all inputs received
            contextp->timeInc(1);
            top->eval();

            getline(line_ss, token, '|'); // get OUT
            expected = std::stoi(token, nullptr);

            sprintf(test_desc, "%s @ time = %s/ %ld",
                    ram_name.c_str(), time.c_str(), contextp->time());

            switch (ram_size)
            {
                case RAM8: got = top->out16_RAM8; break;
                case RAM64: got = top->out16_RAM64; break;
                case RAM512: got = top->out16_RAM512; break;
                case RAM4K: got = top->out16_RAM4K; break;
                case RAM16K: got = top->out16_RAM16K; break;
            }

            assert_equal(got, expected, test_desc);
        }

        cmp_file.close();
    }
    else
    {
        std::cerr << "Error: CMP file not found" << std::endl;
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
            top->load_bit = std::stoi(token, nullptr);

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

    // Register
    cmp_file.open("cmp/Register.cmp");
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
            top->in16 = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get LOAD
            top->load_register = std::stoi(token, nullptr);

            // all inputs received
            top->eval();

            getline(line_ss, token, '|'); // get OUT
            expected = std::stoi(token, nullptr);

            sprintf(test_desc, "Register @ time = %s", time.c_str());
            assert_equal(top->out16_register, expected, test_desc);
        }

        cmp_file.close();
    }
    else
    {
        std::cerr << "Error: CMP file not found" << std::endl;
    }
    
    run_RAM_tests("cmp/RAM8.cmp", RAM8, top, contextp);
    run_RAM_tests("cmp/RAM64.cmp", RAM64, top, contextp);
    run_RAM_tests("cmp/RAM512.cmp", RAM512, top, contextp);
    run_RAM_tests("cmp/RAM4K.cmp", RAM4K, top, contextp);
    run_RAM_tests("cmp/RAM16K.cmp", RAM16K, top, contextp);

    // Counter
    /*
    | time |   in   |reset|load | inc |  out   |
    | 0+   |      0 |  0  |  0  |  0  |      0 |
    | 1    |      0 |  0  |  0  |  0  |      0 |
    */
    cmp_file.open("cmp/PC.cmp");
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
            top->in16 = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get RESET
            top->reset_pc = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get LOAD
            top->load_pc = std::stoi(token, nullptr);

            getline(line_ss, token, '|'); // get INC
            top->inc_pc = std::stoi(token, nullptr);

            // all inputs received
            top->eval();

            getline(line_ss, token, '|'); // get OUT
            expected = std::stoi(token, nullptr);

            sprintf(test_desc, "PC @ time = %s / %ld", time.c_str(), contextp->time());
            assert_equal(top->out16_pc, expected, test_desc);
        }

        cmp_file.close();
    }
    else
    {
        std::cerr << "Error: CMP file not found" << std::endl;
    }


    VL_PRINTF("Test results: %d pass, %d fail\n", num_pass, num_fail);

    top->final();
    return 0;
}
