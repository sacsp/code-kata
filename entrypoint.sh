#!/bin/bash

echo "RUNNING JOB 1"

# Activate virtual environment
source /app/venv/bin/activate

# Check if activation was successful
if [ $? -ne 0 ]; then
    echo "Failed to activate virtual environment"
    exit 1
fi

# Run the first PySpark job using spark-submit
$SPARK_HOME/bin/spark-submit --driver-memory 5g --executor-memory 5g /app/problem-2/generate_csv_spark.py

# Check if the spark-submit was successful
if [ $? -ne 0 ]; then
    echo "Spark job 'other.py' failed"
    exit 1
fi

echo "JOB 1 COMPLETED SUCCESSFULLY"

echo "RUNNING JOB 2"

# Run the second PySpark job using spark-submit
$SPARK_HOME/bin/spark-submit /app/problem-2/anonymize_spark.py

# Check if the spark-submit was successful
if [ $? -ne 0 ]; then
    echo "Spark job 'another.py' failed"
    exit 1
fi

echo "JOB 2 COMPLETED SUCCESSFULLY"

echo "ALL JOBS COMPLETED SUCCESSFULLY"