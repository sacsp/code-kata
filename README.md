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

## Solutions for Above

### Prerequisites:
- Docker (preview) — facing issues while building the image; it works on some machines.

### Setup for Docker run:
- Build Docker Image: docker build -t my-code-kata .
- Run Docker image: docker run -it --rm --name my-code-kata my-code-kata

### Local Setup:
- Python 3.9.x or above
- Python virtual environment to work with
- Create a Python virtual environment:
- Install virtualenv: pip install virtualenv
- Create the virtual environment: python3.9 -m venv <virtual-environment-name>
- Activate the virtual environment: source <PATH-TO-YOUR-VIRTUAL-ENV-NAME>/bin/activate
- Install dependencies: pip install -r requirements.txt

## Problem Statements:

### Problem 1:
- To run, execute: ./p1-run.sh
- Input files are located in the Input folder, and outputs will be stored in Output_files/P1/.

### Problem 2:

- To run, execute either: ./p2-run.sh or ./entrypoint.sh
- Outputs will be stored in Output_files/P2/.

Notes:
Ensure Docker is properly configured for building images.
Modify config.ini with appropriate values before running commands if needed.