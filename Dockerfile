# Use an official Ubuntu runtime as a parent image
FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /app

# Install Python, JDK 11, and other necessary packages
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk python3.9 python3.9-dev python3.9-venv python3-pip python3-wheel build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y openjdk-11-jdk

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Verify JAVA_HOME and Java installation
# RUN echo "JAVA_HOME is set to $JAVA_HOME" && \
#     ls -l $JAVA_HOME && \
#     echo "Java executable path:" && \
#     which java && \
#     java -version

# Install PySpark and other Python dependencies
RUN pip3 install --no-cache-dir pyspark


# Create a virtual environment
RUN python3.9 -m venv venv

# install requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the entire CODE-KATA directory contents into the container at /app
COPY . .

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

# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set the entry point to the entrypoint script
# ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
