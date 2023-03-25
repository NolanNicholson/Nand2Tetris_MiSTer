verilator \
-cc -exe --public --trace --savable \
--compiler msvc +define+SIMULATION=1 \
-O3 --x-assign fast --x-initial fast --noassert \
--converge-limit 6000 \
-Wno-UNOPTFLAT \
--top-module top sim_top.v \
../../rtl/05/Computer.v \
../../rtl/05/CPU.v \
../../rtl/05/Keyboard.v \
../../rtl/05/Screen.v \
../../rtl/05/Memory.v \
../../rtl/05/ROM32K.v
