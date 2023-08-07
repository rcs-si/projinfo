#come up with better function names lmfao

import pandas as pd #pandas to parse csv

'''
import the two csv files
currently importing copies i made into my own directory
in the future i should import directly from source so
the data stays updated
'''
user_df = pd.read_csv('/projectnb/rcsmetrics/pidb/data/projuser.csv', encoding='latin-1')
pi_df = pd.read_csv('/projectnb/rcsmetrics/pidb/data/pidb.csv', encoding='latin-1')

user_labels = ['proj', 'user', 'date']
user_df.columns = user_labels

#print(pi_df.head(10))

"""
currently takes in a project name as a
command line argument and prints out all
the users associated with that project
"""
 
def proj_users(project): #list the user information for projectname Project
    if project in user_df['proj'].values:
        filtered = user_df[user_df['proj'] == project]

        print(filtered)
        return filtered
    else:
        return('Error: Input valid project name')

def pi_projs(pi_login): #list the group + projects for which LPI is either the LPI or Admin Contact
    if (pi_login in pi_df['login'].values) or (pi_login in pi_df['alogin'].values):
        pi_filtered = pi_df[pi_df['login'] == pi_login]
        admin_filtered = pi_df[pi_df['alogin'] == pi_login]

        projects = pd.concat([pi_filtered[['group', 'title']], admin_filtered[['group', 'title']]])

        print(projects)
        return projects
    else:
        return('Error: Input valid login')

def semester(): #not sure how to determine the semesters active project, but i'm assuming its any project that is currently active.
    '''
    working on getting it to print active academic projects, but having problems filtering out the "academic" column
    currently just returns all currently active projects

    also not sure what info the apps team needs back, so currently returning everything
    '''
    filtered = pi_df[(pi_df['status'] == 'active') & (pi_df['academic'] == 'course')]
    pd.set_option('display.max_columns', None)
    #print(filtered)
    projects = filtered[['group', 'title']]
    return projects

    

def proj_pi(project): #given project, returns PI and admin contact
    filtered = pi_df[pi_df['group'] == project]

    cols = ['group', 'login', 'alogin']

    #i was trying to filter out the NaN alogin values but i think i'll just keep them in
    #filtered = filtered.dropna(subset=cols, inplace=True)
    return filtered[cols]


def user_pis(username): #given a user, returns the projects (and PI for that project) that user is part of
    if username in user_df['user'].values:
        projects = user_df[user_df['user'] == username]

        result = pd.DataFrame()

        for project in projects['proj']:
            result = pd.concat([result, proj_pi(project)], ignore_index = True)
        
        return result
    else:
        return("Error: Input valid user login")
