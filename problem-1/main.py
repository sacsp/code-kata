import argparse
import io, os, csv, json, re, sys
import logging
from configparser import ConfigParser, ExtendedInterpolation

# Load configuration
config_path = os.path.split(os.path.dirname(os.path.abspath(__file__)))
config = ConfigParser(interpolation=ExtendedInterpolation())
config.read(os.path.join(config_path[0], "config.ini"))

delimiter = config.get('Settings', 'file_delimiter')
output_file = config_path[0] + config.get('Path','result_file_path')

# Reduce offsets
def reduce_offsets_(offsets):
    reduced_offsets = []
    for idx, width in enumerate(offsets):
        distance = width if idx == 0 else width + reduced_offsets[idx - 1]
        reduced_offsets.append(distance)
    return reduced_offsets

# Split line by fixed widths
def split_line_by_fixed_widths(textline='', offsets=[]):
    line = textline
    offsets = reduce_offsets_(offsets)
    print(offsets)

    for idx, n in enumerate(offsets):
        if idx == len(offsets) - 1:
            continue
        line = re.sub(r"^(.{%d})()" % (n + idx), r"\1%s" % delimiter, line)   
        # print(f"main line : {line}")
        logging.debug(line)

    line = [n.strip() if len(n.strip()) > 0 else '_' for n in line.split(delimiter)]
    return line

# Parse specification
def parse_spec(spec):
    column_names = []
    offsets = []
    include_header = False
    input_encoding = None
    output_encoding = None

    try:
        with open(spec) as spec_file:
            spec = json.load(spec_file)
            column_names = [s.encode("utf-8") for s in spec.get('ColumnNames').split(", ")]
            offsets = [int(s) for s in spec.get('Offsets').split(",")]
            input_encoding = spec.get('InputEncoding')
            include_header = spec.get('IncludeHeader')
            output_encoding = spec.get('OutputEncoding')

        return (
            column_names,
            offsets,
            include_header,
            input_encoding,
            output_encoding,
        )
    except Exception as err:
        logging.error('Cannot parse the spec')
        logging.error(err)

# Run the main process
def run(spec, inputfile):
    column_names, offsets, include_header, input_encoding, output_encoding = parse_spec(spec)
    

    try:
        with open(output_file, 'w') as csv_file:
            writer = csv.writer(csv_file, delimiter=delimiter)
            with open(inputfile, 'r') as f:
                if include_header:
                    writer.writerow(column_names)
                for line_index, line in enumerate(f.readlines()):
                    splitted_line = split_line_by_fixed_widths(line, offsets)
                    print(f"output_by_line : {splitted_line}")
                    writer.writerow(splitted_line)
    except Exception as err:
        logging.error('File IO error')
        logging.error(err)

# Main entry point
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Text to csv')
    parser.add_argument('spec', metavar='F', type=str, help='spec file path')
    parser.add_argument('file', metavar='F', type=str, help='text file path')
    args = parser.parse_args()
    spec = args.spec
    file = args.file
    run(spec, file)
