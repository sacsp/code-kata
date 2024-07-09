import os, sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import udf, regexp_replace, col
from pyspark.sql.types import StringType, DateType
from faker import Faker
from configparser import ConfigParser, ExtendedInterpolation


# Load configuration
config_path = os.path.split(os.path.dirname(os.path.abspath(__file__)))
config = ConfigParser(interpolation=ExtendedInterpolation())
config.read(os.path.join(config_path[0], "config.ini"))


# Get the values from config
base_path = config_path[0]
PII_file_path = base_path + config.get('Path', 'csv_file_path')
file_size_str = config.get('Settings', 'file_size')
app_name = config.get('SPARK_APP_CONFIGS', 'spark.app.name')
master = config.get('SPARK_APP_CONFIGS', 'spark.master')

try:
    target_size = eval(file_size_str)  # Evaluates the string expression to get the integer value
except (SyntaxError, NameError) as e:
    print(f"Error evaluating file size: {e}")

# Initialize Faker
fake = Faker()

# Initialize Spark session
spark = SparkSession.builder \
                    .appName(app_name) \
                    .master(master) \
                    .getOrCreate()

# Define UDFs for generating fake data
@udf(returnType=StringType())
def generate_first_name():
    return fake.first_name()

@udf(returnType=StringType())
def generate_last_name():
    return fake.last_name()

@udf(returnType=StringType())
def generate_address():
    return fake.address().replace("\n", " ")

@udf(returnType=DateType())
def generate_date_of_birth():
    return fake.date_of_birth()


# Function to check file size
def get_file_size(file_path):
    if os.path.exists(file_path):
        return os.path.getsize(file_path)
    else:
        return 0
    

# Generate and append data in chunks until the file size exceeds the target size
chunk_size = 100000  # Number of records per chunk
file_size = get_file_size(PII_file_path)


while file_size < target_size:
    # Create a DataFrame with the chunk of data
    df = spark.range(chunk_size).selectExpr("id + 1 as id")
    df = df.withColumn("first_name", generate_first_name()) \
           .withColumn("last_name", generate_last_name()) \
           .withColumn("address", generate_address()) \
           .withColumn("date_of_birth", generate_date_of_birth()) \
           .drop("id")
    
    # Write the chunk to CSV, append if the file already exists
    df.write.csv(PII_file_path, header=(file_size == 0), mode='append')

    
    # Update the file size
    file_size = get_file_size(PII_file_path)
    print(f"Current file size: {file_size / (1024 * 1024)} MB")



# ------------------------------ END -----------------------------------------------------

sys.exit()








def generate_csv(n):
        fake = Faker('en_AU')
        data = []
        for _ in range(n):
            data.append(
                {
                    "first_name": fake.first_name(),
                    "last_name": fake.last_name(),
                    "address": fake.address().replace("\n", " "),  # Replace newline in address
                    "date_of_birth": fake.date_of_birth()
                }
            )

        people_rdd = spark.sparkContext.parallelize(data)
        people_df = spark.createDataFrame(people_rdd)

        people_schema = people_df \
            .withColumn("first_name", col("first_name").cast(StringType())) \
            .withColumn("last_name", col("last_name").cast(StringType())) \
            .withColumn("address", regexp_replace(col("address"), "\n", " ")) \
            .withColumn("date_of_birth", col("date_of_birth").cast(DateType()))

        return people_schema

# Function to check file size
def get_file_size(file_path):
    if os.path.exists(file_path):
        return os.path.getsize(file_path)
    else:
        return 0
    

# Generate and append data in chunks 
chunk_size = 10000000  # Number of records
file_size = get_file_size(PII_file_path)

person_df = generate_csv(chunk_size)

# Write the chunk to CSV, append if the file already exists
person_df.write.csv(PII_file_path, header=(file_size == 0), mode='append')
 
# Update the file size
file_size = get_file_size(PII_file_path)
print(f"Current file size: {file_size / (1024 * 1024)} MB")










