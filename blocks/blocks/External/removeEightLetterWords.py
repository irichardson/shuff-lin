#!/usr/bin/python

import sys

with open('dictionary.txt', 'r') as f:
    lines = f.readlines()
    f.close
    f = open("dictionary.txt", "w")
    for line in lines:
      print len(line)
      if len(line) <= 7:
        f.write(line)    
f.close()