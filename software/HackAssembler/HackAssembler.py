#!/usr/bin/env python3

import os
import struct
import sys


# Nand to Tetris Chapter 6: Hack Software Assembler
# Nolan Nicholson, 2023
# I decided not to use their program structure, since passing to a
# Parser module and a Code module seemed unnecessarily complicated.


def parse(filename):
    if filename[-4:] != ".asm":
        raise ValueError(filename + " is not a .asm file")
    else:
        filename_output = filename[:-4] + ".hack"

    line_number = 0
    symbol_table = {
            "SP":       0,
            "LCL":      1,
            "ARG":      2,
            "THIS":     3,
            "THAT":     4,
            "SCREEN":   16384,
            "KBD":      24576,
            }
    # R0, R1, ... R15 are also predefined in the symbol table
    for i in range(16):
        symbol_table["R" + str(i)] = i

    # During assembly, this will increment as it gets used
    variable_address = 16

    # First, parse the file once to get label declarations into the symbol table.
    fin = open(filename, "r")
    for line in fin:
        # Strip trailing comments
        if "//" in line:
            line = line[:line.index("//")]
        
        # strip lead/trailing whitespace, including trailing newline
        line = line.strip() 

        # Ignore whitespace-only lines
        if len(line) == 0:
            continue

        is_label_declaration = len(line) >= 3 and line[0] == "(" and line[-1] == ")"
        if is_label_declaration:
            label = line[1:-1]
            symbol_table[label] = line_number
        else:
            line_number += 1

    fin.close()

    # Then, parse it again, to perform the actual assembly.
    fin = open(filename, "r")
    fout = open(filename_output, "w")
    for line in fin:

        # Strip trailing comments
        if "//" in line:
            line = line[:line.index("//")]

        # strip lead/trailing whitespace, including trailing newline
        line = line.strip() 

        # Ignore whitespace-only lines
        if len(line) == 0:
            continue

        # Ignore label declarations (we already handled them on the first pass)
        is_label_declaration = len(line) >= 3 and line[0] == "(" and line[-1] == ")"
        if is_label_declaration:
            continue

        # Handle A-instructions
        if len(line) >= 2 and line[0] == "@":
            a_str = line[1:]
            if a_str.isnumeric():
                a_value = int(a_str)
            elif a_str in symbol_table:
                a_value = symbol_table[a_str]
            else:
                symbol_table[a_str] = variable_address
                a_value = variable_address
                variable_address += 1
            
            instruction = bin(a_value).replace("0b", "").rjust(16, "0")

        # Handle C-instructions
        else:
            if "=" in line:
                dest_i = line.index("=")
                dest = line[:dest_i]
            else:
                dest_i = -1 # this will grab from the start
                dest = ""

            if ";" in line:
                jump_i = line.index(";")
                jump = line[jump_i+1:]
            else:
                jump_i = None # this will grab to (and including) the end
                jump = ""

            comp = line[dest_i+1:jump_i]

            if   comp == "0":   comp_bits = "0101010" 
            elif comp == "1":   comp_bits = "0111111" 
            elif comp == "-1":  comp_bits = "0111010" 
            elif comp == "D":   comp_bits = "0001100" 
            elif comp == "A":   comp_bits = "0110000" 
            elif comp == "M":   comp_bits = "1110000" 
            elif comp == "!D":  comp_bits = "0001101" 
            elif comp == "!A":  comp_bits = "0110001" 
            elif comp == "!M":  comp_bits = "1110001" 
            elif comp == "-D":  comp_bits = "0001111" 
            elif comp == "-A":  comp_bits = "0110011" 
            elif comp == "-M":  comp_bits = "1110011" 
            elif comp == "D+1": comp_bits = "0011111" 
            elif comp == "A+1": comp_bits = "0110111" 
            elif comp == "M+1": comp_bits = "1110111" 
            elif comp == "D-1": comp_bits = "0001110" 
            elif comp == "A-1": comp_bits = "0110010" 
            elif comp == "M-1": comp_bits = "1110010" 
            elif comp == "D+A": comp_bits = "0000010" 
            elif comp == "D+M": comp_bits = "1000010" 
            elif comp == "D-A": comp_bits = "0010011" 
            elif comp == "D-M": comp_bits = "1010011" 
            elif comp == "A-D": comp_bits = "0000111" 
            elif comp == "M-D": comp_bits = "1000111" 
            elif comp == "D&A": comp_bits = "0000000" 
            elif comp == "D&M": comp_bits = "1000000" 
            elif comp == "D|A": comp_bits = "0010101" 
            elif comp == "D|M": comp_bits = "1010101" 
            else: raise ValueError("Invalid comp string encountered: \"" + comp + "\".")

            dest_bits_list = ["0", "0", "0"]
            if "M" in dest: dest_bits_list[2] = "1"
            if "D" in dest: dest_bits_list[1] = "1"
            if "A" in dest: dest_bits_list[0] = "1"
            dest_bits = ''.join(dest_bits_list)

            if   jump == "":    jump_bits = "000"
            elif jump == "JGT": jump_bits = "001"
            elif jump == "JEQ": jump_bits = "010"
            elif jump == "JGE": jump_bits = "011"
            elif jump == "JLT": jump_bits = "100"
            elif jump == "JNE": jump_bits = "101"
            elif jump == "JLE": jump_bits = "110"
            elif jump == "JMP": jump_bits = "111"
            else: raise ValueError("Invalid jump string encountered: \"" + jump + "\".")

            instruction = "111" + comp_bits + dest_bits + jump_bits

        fout.write(instruction + "\n")

    fin.close()
    fout.close()


def convert_file(filename):
    instructions = []

    # get instructions from the input file, in text...
    fin = open(filename, "r")
    for line in fin.readlines():
        instructions.append(int(line, 2)); # append line in base 2
    fin.close()

    print(filename, ": ", instructions)

    # ...and write 'em to the output file, in binary
    fout = open(filename + ".bin", "wb")
    for instruction in instructions:
        fout.write(struct.pack(">H", instruction))
    fout.close()


for filename in os.listdir():
    if filename[-5:] == ".hack":
        convert_file(filename)

if len(sys.argv) < 2:
    print("Usage: HackAssembler.py file1.asm file2.asm ...")
else:
    for i in range(1, len(sys.argv)):
        parse(sys.argv[i])
