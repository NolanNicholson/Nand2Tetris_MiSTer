#!/usr/bin/env python3

import os
import struct

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
