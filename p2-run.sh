#!/bin/bash
# Activate the virtual environment
source ./venv/bin/activate

echo "RUNNING JOB"
driver_memory=10g
executor_memory=10g

# Run the first command
./venv/lib/python3.9/site-packages/pyspark/bin/spark-submit --driver-memory ${driver_memory} --executor-memory ${executor_memory} problem-2/generate_csv_spark.py

# Run the second command (example)
./venv/lib/python3.9/site-packages/pyspark/bin/spark-submit --driver-memory ${driver_memory} --executor-memory ${executor_memory} problem-2/anonymize_spark.py

# Add more commands as needed



#
##!/bin/bash
#
## Source the profile
#source /etc/profile
#
## Set environment variables
#export PYSPARK_PYTHON=python3
#
#echo "RUNNING JOB"
#driver_memory=10g
#executor_memory=10g
#
## PROJECT: Run the main Python script
#echo ""
#echo "$(date)"
#echo "====================================="
#echo "Running pysaprk script for csv to anonymize == Started"
#source ./venv/bin/activate && ./venv/lib/python3.9/site-packages/pyspark/bin/spark-submit --driver-memory ${driver_memory} --executor-memory ${executor_memory} problem-2/generate_csv_spark.py
#source ./venv/bin/activate && ./venv/lib/python3.9/site-packages/pyspark/bin/spark-submit --driver-memory ${driver_memory} --executor-memory ${executor_memory} problem-2/anonymize_spark.py
#echo "Running pysaprk script for csv to anonymize == Completed"
#echo "*************************************"
