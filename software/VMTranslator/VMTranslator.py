#!/usr/bin/env python3

# Nand to Tetris Chapter 7/8: Jack VM Translator to Hack Assembly
# Nolan Nicholson, 2023

import sys

from VMT_CodeWriter import CodeWriter


def translateVM(filename):
    if filename[-3:] != ".vm":
        raise ValueError(filename + " is not a .vm file")
    else:
        filename_noext = filename[:-3]
        filename_output = filename_noext + ".asm"

    f_in = open(filename, "r")
    f_out = open(filename_output, "w")
    cw = CodeWriter(filename_noext)

    for line in f_in:
        # Strip whitespace 
        line = line.strip()
        f_out.write("// " + line + "\n")

        # Strip comments
        if "//" in line:
            line = line[:line.index("//")]

        # Break into words. If no words (because empty line or comment), bail.
        words = line.split()
        if len(words) == 0:
            continue

        command = words[0]
        arg1 = words[1] if len(words) > 1 else None
        arg2 = words[2] if len(words) > 2 else None

        if command == "push":
            command_asm = cw.writePush(arg1, arg2)
        elif command == "pop":
            command_asm = cw.writePop(arg1, arg2)
        elif command in ["add", "sub", "neg", "eq", "gt", "lt", "and", "or", "not"]:
            command_asm = cw.writeArithmetic(command)

        for asm_line in command_asm:
            f_out.write(asm_line + "\n")

    for asm_line in cw.writeFileEnd():
        f_out.write(asm_line + "\n")

    f_out.close()
    f_in.close()


if len(sys.argv) < 2:
    print("Usage: VMTranslator.py file1.vm file2.vm ...")
else:
    for i in range(1, len(sys.argv)):
        translateVM(sys.argv[i])
