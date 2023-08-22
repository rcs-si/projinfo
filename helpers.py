#come up with better function names lmfao + organize this entire file....

import pandas as pd #pandas to parse csv

'''
import the two csv files
'''
user_df = pd.read_csv('/projectnb/rcsmetrics/pidb/data/projuser.csv', encoding='latin-1')
pi_df = pd.read_csv('/projectnb/rcsmetrics/pidb/data/pidb.csv', encoding='latin-1')

user_labels = ['proj', 'user', 'date']
user_df.columns = user_labels

"""
currently takes in a project name as a
command line argument and prints out all
the users associated with that project
"""
def proj(project): #one function to call in projinfo.py
    if project in user_df['proj'].values:
        result = proj_info(project).to_string(index=False)
        result += '\n\n'
        result += proj_users(project)
        return result
    else:
        return('Invalid project name')

def proj_users(project): #list the user information for projectname Project

    filtered = user_df[user_df['proj'] == project]

    result = filtered[['user', 'date']]

    return result.fillna('').to_string(index=False)

def num_users(row): #number of users in a project, currently helper for academic flag
    project = row['group']
    filtered = user_df[user_df['proj'] == project]

    return len(filtered)

def proj_info(project): #given project, returns info (helper for -p)

    filtered = pi_df[pi_df['group'] == project]

    cols = ['group', 'login', 'alogin', 'academic', 'allocation', 'dept', 'center', 'college']

    new_columns = {'group': 'Project', 'login': 'LPI', 'alogin': 'Admin', 'allocation': 'SU_Allocation'}

        #i was trying to filter out the NaN alogin values but i think i'll just keep them in
        #filtered = filtered.dropna(subset=cols, inplace=True)

    result = filtered[cols]
    result = result.rename(columns=new_columns).fillna('')
    return result #.to_string(index=False)



def pi_projs(pi_login): #list the group + projects for which LPI is either the LPI or Admin Contact
    if (pi_login in pi_df['login'].values) or (pi_login in pi_df['alogin'].values):
        pi_filtered = pi_df[pi_df['login'] == pi_login].copy()
        pi_filtered.loc[:,'PI/Admin?'] = 'PI'
        admin_filtered = pi_df[pi_df['alogin'] == pi_login].copy()
        admin_filtered.loc[:,'PI/Admin?'] = "Admin"

        projects = pd.concat([pi_filtered[['group', 'title', 'PI/Admin?']], admin_filtered[['group', 'title', 'PI/Admin?']]])

        return projects.to_string(index=False)
    else:
        return('Invalid user name')

def academic(): #not sure how to determine the semesters active project, but i'm assuming its any project that is currently active.
    '''
    working on getting it to print active academic projects, but having problems filtering out the "academic" column
    currently just returns all currently active projects

    also not sure what info the apps team needs back, so currently returning everything
    '''
    filtered = pi_df[(pi_df['status'] == 'active') & (pi_df['academic'] == 'course')]
    pd.set_option('display.max_columns', None)
    #print(filtered)
    projects = filtered[['group', 'title', 'login', 'alogin', 'dept', 'campus']].copy()
    new_columns = {'group': 'Project', 'login': 'LPI', 'alogin': 'Admin'}

    projects['#Users'] = projects.apply(num_users, axis = 1)
    return projects.rename(columns=new_columns).fillna('').to_string(index=False)

    

def proj_pi(project): #given project, returns PI and admin contact
    filtered = pi_df[pi_df['group'] == project]

    cols = ['group', 'login', 'alogin']

    ['Project/Group', 'PI Login', 'Admin Login']

    new_columns = {'group': 'Project', 'login': 'LPI', 'alogin': 'Admin'}

    #i was trying to filter out the NaN alogin values but i think i'll just keep them in
    #filtered = filtered.dropna(subset=cols, inplace=True)

    result = filtered[cols]
    result = result.rename(columns=new_columns)
    return result #.to_string(index=False)


def user_pis(username): #given a user, returns the projects (and PI for that project) that user is part of
    if username in user_df['user'].values:
        projects = user_df[user_df['user'] == username]

        result = pd.DataFrame()

        for project in projects['proj']:
            result = pd.concat([result, proj_pi(project)], ignore_index = True)
        
        filtered = result.fillna('')
        return filtered.to_string(index=False)
    else:
        return("Invalid user name")

def vuser_pis(username): #given a user, returns the projects (and PI for that project) that user is part of
    if username in user_df['user'].values:
        projects = user_df[user_df['user'] == username]

        result = pd.DataFrame()

        for project in projects['proj']:
            result = pd.concat([result, proj_info(project)], ignore_index = True)
        
        filtered = result.fillna('')
        return filtered.to_string(index=False)
    else:
        return("Invalid user name")

def vpi_projs(pi_login): #list the group + projects for which LPI is either the LPI or Admin Contact
    if (pi_login in pi_df['login'].values) or (pi_login in pi_df['alogin'].values):
        pi_filtered = pi_df[pi_df['login'] == pi_login].copy()
        pi_filtered.loc[:,'PI/Admin?'] = 'PI'
        admin_filtered = pi_df[pi_df['alogin'] == pi_login].copy()
        admin_filtered.loc[:,'PI/Admin?'] = "Admin"

        projects = pd.concat([pi_filtered[['group', 'title', 'PI/Admin?', 'dept', 'campus']], admin_filtered[['group', 'title', 'PI/Admin?', 'dept', 'campus']]])
        projects['#Users'] = projects.apply(num_users, axis = 1)
        return projects.to_string(index=False)
    else:
        return('Invalid user name')