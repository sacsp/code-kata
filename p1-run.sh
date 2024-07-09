#!/bin/bash

# Source the profile
source /etc/profile

# Set environment variables
export PYSPARK_PYTHON=python3

echo "RUNNING JOB"
# driver_memory=10g
# executor_memory=10g

# Set the path to the spec file and the input file
SPEC_FILE="Input_files/spec.json"
INPUT_FILE="Input_files/input.txt"

# PROJECT: Run the main Python script
echo ""
echo "$(date)"
echo "====================================="
echo "Running main.py script == Started"
source ./venv/bin/activate && python problem-1/main.py "$SPEC_FILE" "$INPUT_FILE"
echo "Running main.py script == Completed"
echo "**************************************"
