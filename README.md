# Data Engineering Coding Challenges

## Judgment Criteria

- Beauty of the code (beauty lies in the eyes of the beholder)
- Testing strategies
- Basic Engineering principles

## Problem 1

### Parse fixed width file

- Generate a fixed width file using the provided spec (offset provided in the spec file represent the length of each field).
- Implement a parser that can parse the fixed width file and generate a delimited file, like CSV for example.
- DO NOT use python libraries like pandas for parsing. You can use the standard library to write out a csv file (If you feel like)
- Language choices (Python or Scala)
- Deliver source via github or bitbucket
- Bonus points if you deliver a docker container (Dockerfile) that can be used to run the code (too lazy to install stuff that you might use)
- Pay attention to encoding

## Problem 2

### Data processing

- Generate a csv file containing first_name, last_name, address, date_of_birth
- Process the csv file to anonymise the data
- Columns to anonymise are first_name, last_name and address
- You might be thinking  that is silly
- Now make this work on 2GB csv file (should be doable on a laptop)
- Demonstrate that the same can work on bigger dataset
- Hint - You would need some distributed computing platform

## Choices

- Any language, any platform
- One of the above problems or both, if you feel like it.


## solutions 
- Folder Structure:
CODE-KATA/
├── Input_files/
│   ├── input.txt
│   └── speck.json
├── Output_files/
│   ├── p1
│   └── p2
├── problem-1/
│   ├── main.py
│   └── test_main.py
├── problem-2/
│   ├── generate_csv_spark.py
│   └── anonymize_spark.py
├── config.ini
├── README.MD
├── requirements.txt
└── Dockerfile

##
Prerequisites
Python3.6.x or above
Python virtual environment to work with

Activate the virtual environment created earlier by running the following command . <PATH-TO-YOUR-VIRTUAL-ENV-NAME>/bin/activate

Run the following command to install all the dependencies pip install -r requirements.txt

xecution of Programs
For programs that start with py_* are a general ones. So use python <PATH-TO-PROGRAM>

For programs that start with pyspark_* use spark-submit <PATH-TO-PROGRAM>
