from Parser import lib_parser
import datetime
import timeit
import time

execution_time = timeit.timeit('''
from Parser import parseReplace
file_name = "Schedule.xml"

with open(file_name, encoding='utf-8', mode='r') as file:
   file = file.read()

parseReplace(file, 0)

''', number = 100)
print(execution_time)

execution_time = timeit.timeit('''
from Parser import lib_parser
file_name = "Schedule.xml"

lib_parser(file_name)

''', number = 100)
print(execution_time)

execution_time = timeit.timeit('''
from Parser import to_dict, to_yaml
file_name = "Schedule.xml"

with open(file_name, encoding='utf-8', mode='r') as file:
   file = to_dict(file.read())

to_yaml(file, 0)

''', number = 100)
print(execution_time)

execution_time = timeit.timeit('''
from Parser import parse_regex
file_name = "Schedule.xml"

parse_regex(file_name)

''', number = 100)
print(execution_time)