# Simple Verilator makefile for simulation/testing.
# Based on Verilator examples

TOP = --top-module top
RTL = ../../rtl
V_SRC = \
		$(wildcard $(RTL)/03/*.v) \
		top.v


######################################################################
# Check for sanity to avoid later confusion

ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif

# Flags
# Generate C++ in executable form
VERILATOR_FLAGS += -cc --exe
# Make waveforms
VERILATOR_FLAGS += --trace

default:
	@echo "\n-- VERILATE & BUILD --------\n"
	$(VERILATOR) ${VERILATOR_FLAGS} --build -j $(TOP) $(V_SRC) sim_main.cpp
	@echo "\n-- RUN ---------------------\n"
	@rm -rf logs
	@mkdir -p logs
	obj_dir/Vtop +trace
	@echo "\n-- DONE --------------------\n"

######################################################################

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir logs *.log *.dmp *.vpd core
