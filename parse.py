"""
currently takes in a project name as a
command line argument and prints out all
the users associated with that project
"""
import pandas as pd #pandas to parse csv
import sys #take in sys args

df = pd.read_csv('projuser.csv')

labels = ['proj', 'user', 'date']

df.columns = labels

projname = str(sys.argv[1])

filtered = df[df['proj'] == projname]

print(filtered)
