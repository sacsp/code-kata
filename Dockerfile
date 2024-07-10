# Use an official Ubuntu runtime as a parent image
FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /app

# Install Python, JDK 11, and other necessary packages
RUN apt-get update 
RUN apt-get install -y openjdk-11-jdk 
RUN apt-get install -y wget 
RUN apt-get install -y python3.9 
RUN apt-get install -y python3.9-dev 
RUN apt-get install -y python3.9-venv 
RUN apt-get install -y python3-pip 
RUN apt-get install -y python3-wheel 
RUN apt-get install -y build-essential
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*


# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
ENV PATH="$JAVA_HOME/bin:$PATH"


# Download and install Apache Spark
ENV SPARK_VERSION=3.5.1
ENV HADOOP_VERSION=3
RUN wget -O /tmp/spark.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvf /tmp/spark.tgz -C /opt && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark && \
    rm /tmp/spark.tgz

# Set SPARK_HOME environment variable
ENV SPARK_HOME=/opt/spark
ENV PATH="$SPARK_HOME/bin:$PATH"

ENV PYSPARK_PYTHON=python3


# Install PySpark and other Python dependencies
RUN pip3 install --no-cache-dir pyspark


# Create a virtual environment
RUN python3.9 -m venv venv

# Ensure pip is up-to-date
RUN venv/bin/pip install --upgrade pip

# install requirements
COPY requirements.txt .
# Install any needed packages specified in requirements.txt using the virtual environment's pip

RUN venv/bin/pip install --no-cache-dir -r requirements.txt
# RUN pip3 install --no-cache-dir -r requirements.txt

# RUN apt-get update \
#     && apt-get install -y \
#     && pip install --no-cache-dir -r requirements.txt \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# RUN pip3 install Faker

# Copy the entire CODE-KATA directory contents into the container at /app
COPY . /app
WORKDIR /app

# Ensure the Output_files/p1 and Output_files/p2 directories exist
RUN mkdir -p /app/Output_files/p1 /app/Output_files/p2

# Verify installation and environment setup
RUN echo "Current working directory:" && pwd
RUN echo "Files in current directory:" && ls -l
RUN echo "Files in /app/Output_files/p1:" && ls -l /app/Output_files/p1
RUN echo "Files in /app/Output_files/p2:" && ls -l /app/Output_files/p2
RUN echo "Java version:" && java -version
RUN echo "Python version:" && python3 --version
# RUN echo "PySpark version:" && /bin/bash -c "source venv/bin/activate && python3 -c 'import pyspark; print(pyspark.__version__)'"

# Add volumes for mapping host directories to container directories
VOLUME ["/app/Output_files/p1/", "/app/Output_files/p2/"]

# Make the run.sh scripts executable
RUN chmod +x p1-run.sh
RUN chmod +x p2-run.sh
RUN chmod +x ./venv/bin/activate

# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh


