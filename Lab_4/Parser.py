import xmltodict
import yaml
import re
import line_profiler

#@profile
def lib_parser(file_name):
    with open(file_name, encoding='utf-8', mode='r') as file:
        file = xmltodict.parse(file.read())
    file = yaml.dump(file, allow_unicode=True, sort_keys=False)
    return file

#@profile
def find_close_teg(file, teg):
    count_open = 1
    count_close = 0
    for i in range(len(file)-len(teg)-2):
        if file[i]=='<':
            if file[i:i+len(teg)+2]=='<' + teg + '>':
                count_open += 1
            elif file[i:i+len(teg)+3]=='</' + teg + '>':
                count_close += 1
        if count_close == count_open:
            return i
    else:
        print(teg)
        print("Неправильный xml-файл")
        return 'o'

#@profile
def format(f):
    while f[0]==' ':
        f = f[1::]
    while f[-1]==' ':
        f = f[:len(f)-1:]
    return f.replace('  ', '').replace('<!--', '# ').replace('-->', '\n')

#@profile
def to_dict(file):
    file = format(file)
    dct = {}
    if '</' not in file:
        return file.replace('&quot', '\"').replace('&apos', '\'').replace('&lt', '<').replace('&gt', '>').replace('&amp', '&')
    start = 0
    end = 0
    while start<len(file):
        if file[start] == '<' and file[start + 1]=='?' and start < (len(file) - 2):
            while file[start]!='>':
                start +=1
        if file[start]=='<' and file[start+1] != '/' and start<(len(file)-1):
            end = start
            while (file[end]!='>') and end<len(file):
                end +=1
            teg = file[start+1:end:]
            if teg in dct:
                if type(dct[teg]) is not list:
                    dct[teg] = [dct[teg]]
                dct[teg].append(to_dict(file[end+1:end + 1 + find_close_teg(file[end+1::], teg):]))
            else:
                dct[teg]=to_dict(file[end+1:end + 1 + find_close_teg(file[end+1::], teg):])
            start = end + find_close_teg(file[end+1::], teg)
        start += 1
    return dct

#@profile
def to_yaml(file, layer):
    new_file = ''
    for item in file:
        if type(file[item]) is list:
            new_file += '  '*layer + item + ':\n'
            for lst_itm in file[item]:
                keys = list(lst_itm.keys())
                lst_itm['- '+keys[0]] = lst_itm.pop(keys[0])
                for i in range(1, len(lst_itm)):
                    lst_itm['  ' + keys[i]] = lst_itm.pop(keys[i])
                new_file += to_yaml(lst_itm, layer+1)
        else:
            if type(file[item]) is dict:
                new_file += '  '*layer + item + ':\n'
                new_file += to_yaml(file[item], layer + 1)
            else:
                new_file += '  '*layer + item + ': ' + file[item] + '\n'
    return new_file

#@profile
def parse_formal(file_name):
    with open(file_name, encoding='utf-8', mode='r') as file:
        file = file.read()
    file = to_dict(file)
    new_file = open('Schedule_yaml.txt', encoding='utf-8', mode='x')
    '''new_file += '---\n'
    new_file += to_yaml(file, 0)
    new_file += '...'''''
    new_file.write('---\n')
    new_file.write(to_yaml(file, 0))
    new_file.write('...')
    print('Файл успешно переведен из xml в yaml')
    #return new_file

#@profile
def parse_main(file_name):
    with open(file_name, encoding='utf-8', mode='r') as file:
        file = file.read()
    new_file = open('Schedule_yaml_1.txt', encoding='utf-8', mode='x')
    new_file.write('---')
    new_file.write(parseReplace(file, 0))
    new_file.write('\n...')
    return 'Файл успешно переведен из xml в yaml(1)'

#@profile
def parseReplace(file, layer):
    file = format(file)
    new_file = ''
    if '<' not in file:
        return file
    start = 0
    while start<=(len(file)-1):
        if file[start]=='<' and file[start+1]!='/' and start<(len(file)-1):
            end = start
            while file[end]!='>':
                end+=1
            teg = file[start+1:end]
            new_file += '\n' + '  '*layer + teg + ': ' + parseReplace(file[end+1:end + 1 + find_close_teg(file[end+1::], teg)], layer + 1)
            start = end + find_close_teg(file[end+1::], teg)
        start += 1
    return new_file

#@profile
def tab(file):
    start = 0
    while start<(len(file)-1):
        if file[start]=='<':
            if file[start+1]!='/':
                file = file[:start+1:] + '&&' + file[start+1::]
            start += 2
        start += 1
    return file

#@profile
def parse_regex(file_name):
    pattern = r'<(&{0,})((?:\w|\d){0,})>((?:.|\n[^[<>/]]){0,})</\2>'
    format_pattern = r'>(?:\n| ){0,}<'
    with open(file_name, encoding='utf-8', mode='r') as file:
        file = file.read()
    file = re.sub(format_pattern, '><', file)
    while '<' and '>' in file:
        file = re.sub(pattern, r'\n\1\2: \3', file)
        file = tab(file)
    print(file.replace('&&', '  '))

file_name = "Schedule.xml"

with open(file_name, encoding='utf-8', mode='r') as file:
    file = file.read()

file = to_dict(file)

lib_parser(file_name)
to_yaml(file, 0)