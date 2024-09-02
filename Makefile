# Comprehensive Makefile for ASIC and FPGA design projects
# Created by: Rauf Emre Erkiletlioglu on 2024-09-01

# Tools
YOSYS := yosys
IVERILOG := iverilog
VVP := vvp
GTKWAVE := gtkwave
DOT := dot
VERILATOR := verilator

# Directories
SRC_DIR := source
TB_DIR := testbench
WAVES_DIR := waves
OUTPUT_DIR := outputs
IMPORT_DIR := imports

# Sub Directories of OUTPUT_DIR
OUTPUT_DIR_RTL := $(OUTPUT_DIR)/rtl
OUTPUT_DIR_SYN := $(OUTPUT_DIR)/syn
OUTPUT_DIR_SIM := $(OUTPUT_DIR)/sim

# Source and testbench files
SRC_FILE := $(wildcard $(SRC)/$(SRC_DIR)/$(SRC).sv)
TB_FILE := $(wildcard $(SRC)/$(TB_DIR)/$(SRC)_tb.sv)

# Import directories and files
IMPORT_DIRS := $(shell cat $(SRC)/$(IMPORT_DIR)/import.txt)
IMPORT_PATHS := $(addprefix -I,$(IMPORT_DIRS)/$(SRC_DIR))

# All Verilog sources
VERILOG_SOURCES := $(SRC_FILE) $(IMPORT_FILES)

# Output files
VVP_FILE := $(SRC)/$(OUTPUT_DIR_SIM)/$(SRC)_tb.vvp
VCD_FILE := $(SRC)/$(WAVES_DIR)/$(SRC).vcd
SYNTH_FILE := $(SRC)/$(OUTPUT_DIR_SYN)/$(SRC)_synth.v
RTL_DOT_FILE := $(SRC)/$(OUTPUT_DIR_RTL)/$(SRC)_rtl.dot
RTL_PNG_FILE := $(SRC)/$(OUTPUT_DIR_RTL)/$(SRC)_rtl.png

# Top module
TOP_MODULE := $(SRC)

# Simulation runtime
SIM_RUNTIME := 5000ns

.PHONY: sim syn rtl view clean setup help debug

# Run all targets (not yet completed, do not run)
all: sim syn rtl

# Simulation
sim: $(VCD_FILE)

$(VVP_FILE): $(VERILOG_SOURCES) $(TB_FILE)
	mkdir -p $(SRC)/$(OUTPUT_DIR_SIM)
	$(IVERILOG) -g2012 $(IMPORT_PATHS) -o $@ $^

$(VCD_FILE): $(VVP_FILE)
	mkdir -p $(SRC)/$(WAVES_DIR)
	$(VVP) $<

# View waveforms
view: $(VCD_FILE)
	$(GTKWAVE) $<

# Synthesis
syn: $(SYNTH_FILE)

$(SYNTH_FILE): $(VERILOG_SOURCES)
	mkdir -p $(SRC)/$(OUTPUT_DIR_SYN)
	$(YOSYS) -p "read_verilog -sv $(IMPORT_PATHS) $^; synth -top $(TOP_MODULE); write_verilog $@"

# RTL diagram generation
rtl: $(RTL_PNG_FILE)

$(RTL_DOT_FILE): $(VERILOG_SOURCES)
	mkdir -p $(SRC)/$(OUTPUT_DIR_RTL)
	$(YOSYS) -p "read_verilog -sv $(IMPORT_PATHS) $^; hierarchy -top $(TOP_MODULE); proc; opt; fsm; opt; memory; opt; show -format dot -prefix $(SRC)/$(OUTPUT_DIR_RTL)/$(SRC)_rtl"

$(RTL_PNG_FILE): $(RTL_DOT_FILE)
	$(DOT) -Tpng $< -o $@

# Verilator linting
lint: $(VERILOG_SOURCES)
	verilator --lint-only -Wall $(IMPORT_PATHS) $^

# Clean up
clean:
	rm -rf $(SRC)/$(OUTPUT_DIR)
	rm -rf $(SRC)/$(WAVES_DIR)

# Setup project
setup:
	mkdir -p $(SRC)/$(SRC_DIR)
	mkdir -p $(SRC)/$(TB_DIR)
	mkdir -p $(SRC)/$(WAVES_DIR)
	mkdir -p $(SRC)/$(OUTPUT_DIR)
	mkdir -p $(SRC)/$(OUTPUT_DIR_RTL)
	mkdir -p $(SRC)/$(OUTPUT_DIR_SYN)
	mkdir -p $(SRC)/$(OUTPUT_DIR_SIM)
	mkdir -p $(SRC)/$(IMPORT_DIR)
	
	@echo "module $(SRC)();\n\nendmodule" > $(SRC)/$(SRC_DIR)/$(SRC).sv
	
	@echo "\`timescale 1ns/1ps\nmodule $(SRC)_tb;\n\t$(SRC) uut ();\n\tinitial begin\n\t\t// Generate VCD file\n\t\t\$$dumpfile(\"$(SRC)/$(WAVES_DIR)/$(SRC).vcd\");\n\t\t\$$dumpvars(0, $(SRC)_tb);\n\t\t\$$finish;\n\tend\nendmodule" > $(SRC)/$(TB_DIR)/$(SRC)_tb.sv
	
	@echo "# Add import directories here, one per line\n# Example:\n# full_adder" > $(SRC)/$(IMPORT_DIR)/import.txt

# Help
help:
	@echo ""
	@echo "Usage:"
	@echo "  make SRC=module_name [target]"
	@echo ""
	@echo "Targets:"
	@echo "  sim    - Run simulation"
	@echo "  view   - View waveforms"
	@echo "  syn    - Synthesize design"
	@echo "  rtl    - Generate RTL diagram"
	@echo "  lint   - Run Verilator linting"
	@echo "  clean  - Remove generated files"
	@echo "  setup  - Set up project directory structure"
	@echo "  help   - Show this help message"
	@echo ""

# Default target
.DEFAULT_GOAL := help

# Debug target
debug:
	@echo "SRC = $(SRC)"
	@echo "Source file: $(SRC_FILE)"
	@echo "Testbench file: $(TB_FILE)"
	@echo "Import directories: $(IMPORT_DIRS)"
	@echo "Import files: $(IMPORT_FILES)"
	@echo "Import paths: $(IMPORT_PATHS)"
	@echo "All Verilog sources: $(VERILOG_SOURCES)"
	@echo "VVP_FILE = $(VVP_FILE)"
	@echo "VCD_FILE = $(VCD_FILE)"
	@echo "TOP_MODULE = $(TOP_MODULE)"
	@echo "Source directory contents:"
	@ls -l $(SRC)/$(SRC_DIR)
	@echo "Testbench directory contents:"
	@ls -l $(SRC)/$(TB_DIR)
	@echo "Import directory contents:"
	@ls -l $(SRC)/$(IMPORT_DIR)
	@echo "Import file contents:"
	@cat $(SRC)/$(IMPORT_DIR)/import.txt