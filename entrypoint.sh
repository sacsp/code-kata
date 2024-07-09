#!/bin/bash
# Activate the virtual environment
source ./venv/bin/activate

echo "RUNNING JOB"
driver_memory=10g
executor_memory=10g

# Run the first command
./venv/lib/python3.9/site-packages/pyspark/bin/spark-submit --driver-memory ${driver_memory} --executor-memory ${executor_memory} problem-2/generate_csv_spark.py

# Run the second command (example)
./venv/lib/python3.9/site-packages/pyspark/bin/spark-submit --driver-memory ${driver_memory} --executor-memory ${executor_memory} problem-2/another_script.py

# Add more commands as needed
