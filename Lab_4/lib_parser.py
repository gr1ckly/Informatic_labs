import re

file_name = 'Schedule.xml'

def tab(file):
    start = 0
    while start<(len(file)-1):
        if file[start]=='<':
            if file[start+1]!='/':
                file = file[:start+1:] + '&&' + file[start+1::]
            start += 2
        start += 1
    return file

def parse_regex(file_name):
    pattern = r'<(&{0,})((?:\w|\d){0,})>((?:.|\n[^[<>/]]){0,})</\2>'
    format_pattern = r'>(?:\n| ){0,}<'
    with open(file_name, encoding='utf-8', mode='r') as file:
        file = file.read()
    file = re.sub(format_pattern, '><', file)
    while '<' and '>' in file:
        file = re.sub(pattern, r'\n\1\2: \3', file)
        file = tab(file)
    return file.replace('&', ' ')
print(parse_regex(file_name))