from pyspark.sql import SparkSession
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType
from faker import Faker
from configparser import ConfigParser, ExtendedInterpolation
import os, sys
import hashlib

config_path = os.path.split(os.path.dirname(os.path.abspath(__file__)))
config = ConfigParser(interpolation=ExtendedInterpolation())
config.read(os.path.join(config_path[0], "config.ini"))


# Get the values from config
base_path = config_path[0]
input_path = base_path + config.get('Path', 'csv_file_path')
output_path = base_path + config.get('Path', 'anonymized_csv_file_path')
app_name = config.get('SPARK_APP_CONFIGS', 'spark.app.name')
master = config.get('SPARK_APP_CONFIGS', 'spark.master')


# Initialize Spark session
spark = SparkSession.builder \
                    .appName(app_name) \
                    .master(master) \
                    .getOrCreate()


# Define the anonymize function
def anonymize(value):
    return hashlib.sha256(value.encode()).hexdigest()

# Register the anonymize function as a UDF
anonymize_udf = udf(anonymize, StringType())

def anonymize_csv(input_path, output_path):
    # Read the CSV file into a Spark DataFrame
    df = spark.read.csv(input_path, header=True, inferSchema=True)
    
    # Apply the anonymize function to the relevant columns
    df = df.withColumn('first_name', anonymize_udf(df['first_name'])) \
           .withColumn('last_name', anonymize_udf(df['last_name'])) \
           .withColumn('address', anonymize_udf(df['address']))
    
    # Write the anonymized DataFrame back to a CSV file
    df.write.csv(output_path, header=True, mode='overwrite')

# Example usage
anonymize_csv(input_path, output_path)
