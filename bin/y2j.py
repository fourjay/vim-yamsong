#!/usr/bin/env python3
'''
Simple yaml -> json converter
'''


import sys
import json
import yaml
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('indent_level', nargs='?', type=int, default=4)
parser.add_argument('json_file', nargs='?', type=argparse.FileType('r'), default=sys.stdin)

file = parser.parse_args().json_file
indent_level = parser.parse_args().indent_level

body = yaml.safe_load(file.read())
json_body = json.dumps(body, indent=indent_level, separators=(',', ': '))
print(json_body, end='')
