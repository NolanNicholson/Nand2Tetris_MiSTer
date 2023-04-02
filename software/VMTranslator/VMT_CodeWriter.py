# Nand to Tetris Chapter 7/8: Jack VM Translator to Hack Assembly
# VMT_CodeWriter module: prepares assembly instructions
# Nolan Nicholson, 2023


segmentCodes = {
        "local": "LCL",
        "argument": "ARG",
        "this": "THIS",
        "that": "THAT"
        }


class CodeWriter:
    filename = "Foo"
    gt_index = 0
    lt_index = 0
    eq_index = 0


    def __init__(self, filename):
        self.filename = filename


    """
    Write the end of the assembly file.
    """
    def writeFileEnd(self):
        return [
                "(DONE_LOOP)",
                "@DONE_LOOP",
                "0;JMP"
                ]


    """
    Point M to SEG[i], for subsequent reads or writes.
    """
    def addressSEG(self, SEG, i):
        return [
                # set D to base address of segment
                f"@{SEG}",
                "D=M",
                # add index i to A
                f"@{i}",
                "A=D+A",
                ]


    """
    Address segment[i]. After this, M will point at
    the desired value for all segments except constant.
    For constant, use A instead of M.
    """
    def addressSegment(self, segment, i):
        if segment in segmentCodes:
            SEG = segmentCodes[segment]
            return addressSEG(SEG, i)

        elif segment == "pointer":
            # pointer 0 maps directly to THIS; 1 to THAT
            return ["@THIS" if i == 0 else "@THAT"]

        elif segment == "temp":
            # temp i (where i is 0 to 7) maps onto RAM[5+i]
            return [f"@{5+i}"]

        elif segment == "constant":
            return [f"@{i}"]

        elif segment == "static":
            return [f"@{self.filename}.{i}"]


    """
    Push D to the stack.
    """
    def pushD(self):
        return [
                # RAM[SP++] = D
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1"
                ]

    """
    Pop from the stack, leaving M pointed at the top value.
    """
    def popM(self):
        return [
                # Point to RAM[--SP]
                "@SP",
                "AM=M-1",
                ]

    """
    Pop D from the stack.
    """
    def popD(self):
        return self.popM() + ["D=M"]


    """
    Push segment[i] to the stack.
    """
    def writePush(self, segment, i):
        routine = self.addressSegment(segment, i)

        # Set D to the addressed value
        if segment == "constant":
            routine += ["D=A"]
        else:
            routine += ["D=M"]

        routine += self.pushD()
        return routine


    """
    Pop from the stack to segment[i].
    """
    def writePop(self, segment, i):
        # Pop value from the stack and put it in R15
        routine = popD()
        routine += [
                "@R15",
                "M=D"
                ]
        routine += self.addressSegment(segment, i)
        # TODO: reduce instruction count - avoid regs if possible
        routine += [
                # save address to R14
                "D=A",
                "@R14",
                "M=D",
                # load from R15 back into D
                "@R15",
                "D=M",
                # load D value to target address
                "@R14",
                "A=M",
                "M=D"
                ]
        return routine

    """
    Write out an arithmetic command.
    """
    def writeArithmetic(self, command):
        routine = []

        # Pop operands. Some commands only require one operand.
        if command not in ["neg", "not"]:
            routine += self.popD()
        routine += self.popM()

        # Perform operation
        if command == "add":
            routine += ["D=D+M"]

        elif command == "sub":
            routine += ["D=M-D"]

        elif command == "neg":
            routine += ["D=-M"]

        elif command == "and":
            routine += ["D=D&M"]

        elif command == "or":
            routine += ["D=D|M"]

        elif command == "not":
            routine += ["D=!M"]

        elif command in ["eq", "lt", "gt"]:
            if command == "eq":
                comparison = "JEQ"
                if_true = f"CONDJMP_eq_{self.eq_index}"
                afterward = f"CONDRET_eq_{self.eq_index}"
                self.eq_index += 1
            elif command == "lt":
                comparison = "JLT"
                if_true = f"CONDJMP_lt_{self.lt_index}"
                afterward = f"CONDRET_lt_{self.lt_index}"
                self.lt_index += 1
            elif command == "gt":
                comparison = "JGT"
                if_true = f"CONDJMP_gt_{self.gt_index}"
                afterward = f"CONDRET_gt_{self.gt_index}"
                self.gt_index += 1

            routine += [
                    # Evaluate condition
                    "D=M-D",
                    f"@{if_true}",
                    f"D;{comparison}",

                    # If not true
                    "D=0",
                    f"@{afterward}",
                    "0;JMP",

                    # If true
                    f"({if_true})",
                    "D=1",

                    # Afterward
                    f"({afterward})"
                    ]

        # Push result
        routine += self.pushD()

        return routine

