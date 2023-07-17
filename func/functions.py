#come up with better function names lmfao

import pandas as pd #pandas to parse csv

'''
import the two csv files
currently importing copies i made into my own directory
in the future i should import directly from source so
the data stays updated
'''
user_df = pd.read_csv('projuser.csv')
pi_df = pd.read_csv('pidb.csv')

user_labels = ['proj', 'user', 'date']
user_df.columns = user_labels

"""
currently takes in a project name as a
command line argument and prints out all
the users associated with that project
"""
 
def proj_users(projname): #list the user information for projectname Project

    filtered = user_df[user_df['proj'] == projname]

    print(filtered)
    return filtered

def pi_projs(pi_login): #list the group + projects for which LPI is either the LPI or Admin Contact

    pi_filtered = pi_df[pi_df['login'] == pi_login]
    admin_filtered = pi_df[pi_df['alogin'] == pi_login]

    projects = pd.concat([pi_filtered[['group', 'title']], admin_filtered[['group', 'title']]])

    print(projects)
    return projects

def semester(): #not sure how to determine the semesters active project, but i'm assuming its any project that is currently active.
    '''
    working on getting it to print active academic projects, but having problems filtering out the "academic" column
    currently just returns all currently active projects

    also not sure what info the apps team needs back, so currently returning everything
    '''
    activity = (pi_df['status'] == 'active')
    #academic = (pi_df['academic'] == "")

    filtered = pi_df[activity]
    pd.set_option('display.max_columns', None)
    print(filtered.head(1))
    projects = filtered[['group', 'title']]
    return projects