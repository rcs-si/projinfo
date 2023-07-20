#!/usr/bin/env python3

from argparse import ArgumentParser #take in sys arg
from helpers import *
    #proj_users, pi_projs, semester, proj_pi, user_pis

def main(): #parse arguments, returns input in a dictionary
    '''
    once i add more queries i think i'll create a dictionary of inputs and corresponding outputs
    currently 
    '''
    #create parser + define arguments
    parser = ArgumentParser(description='tool to return information about current projects and PIs') #not sure where this description will show up so idk what to put here lol
    parser.add_argument('-p', '--project', help='Project name')
    parser.add_argument('-u', '--user', help='User login name')
    parser.add_argument('-s', '--semester', help='Current semesters projects')
    parser.add_argument('-pi', '--lpi', help='PI login name')

    args = parser.parse_args()

    #create a dictionary of all the flags
    inputs = vars(args)  #this should automatically set the flags with no input to None
    print(inputs)

    #process the flags and print their outputs?
    #curently have no set output for combinations of flags, so multiple flags will print each corresponding individual output

    for flag, value in inputs.items():
        if value is not None:
            if flag == 'project':
                print(proj_pi(value))
                print(proj_users(value))
            if flag == 'user':
                print(user_pis(value))
            if flag == 'semester':
                print(semester())
            if flag == 'lpi':
                print(pi_projs(value))


if __name__ == "__main__":
    main()










''' 
def main():
    '''
'''
    adding the arg parse code here!
    - use dictionary to map inputs to functions
    '''
'''
    #create parser + define arguments
    parser = ArgumentParser(description='tool to return information about current projects and PIs') #not sure where this description will show up so idk what to put here lol
    parser.add_argument('function', help='function name: proj_users, pi_projs, semester')
    parser.add_argument('-i', '--input', help='input for functions that require it: project name for proj_users, PI name for pi_projs')

    #take in command line arguments
    args = parser.parse_args()

    #save the arguments
    function = args.function
    #print('input function:', function)

    if args.input:
        func_input = args.input
        #print('input func input:', func_input)

    #dictionary to map different functions
    functions = {
        'proj_users': proj_users,
        'pi_projs': pi_projs,
        'semester': semester
    }

    call = functions.get(function) #use .get() to avoid KeyError

    if call:
        if 'func_input' in locals(): #check for secondary input
            call(func_input)
        else:
            call()
    else:
        print("invalid input")

if __name__ == '__main__':
    main()
'''