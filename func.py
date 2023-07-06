"""
currently takes in a project name as a
command line argument and prints out all
the users associated with that project
"""
import pandas as pd #pandas to parse csv
#import sys #take in sys arg

user_df = pd.read_csv('projuser.csv')
pi_df = pd.read_csv('pidb.csv')

user_labels = ['proj', 'user', 'date']
user_df.columns = user_labels

def print_users(projname, df) #list the user information for projectname Project

    filtered = df[df['proj'] == projname]

    print(filtered)

def pi_proj(projname, df) #list the projects for which LPI is either the LPI or Admin Contact

    filtered = df[df['proj'] == projname]

    print(filtered)




