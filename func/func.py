#come up with better function names lmfao

import pandas as pd #pandas to parse csv
from argparse import ArgumentParser #take in sys arg

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

    filtered = pi_df[pi_df['login'] == pi_login]

    projects = filtered[['group', 'title']]

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

#****************************************************************************************#
'''
adding the arg parse code here!
- use dictionary to map inputs to functions
'''
#create parser + define arguments
parser = ArgumentParser(description='tool to return information about current projects and PIs') #not sure where this description will show up so idk what to put here lol
parser.add_argument('arg1', help='function name: proj_users, pi_projs, semester')
parser.add_argument('--optional', help='project name for proj_users, PI name for pi_projs')

#take in command line arguments
args = parser.parse_args()

#save the arguments
function = args.arg1
print('input function:', function)

if args.optional:
    func_input = args.optional
    print('input func input:', func_input)

#dictionary to map different functions
functions = {
    'proj_users': proj_users,
    'pi_projs': pi_projs,
    'semester': semester
}

call = functions.get(function) #use .get to avoid KeyError

if call:
    if 'func_input' in locals(): #check for secondary input
        call(func_input)
    else:
        call()
else:
    print("invalid input")