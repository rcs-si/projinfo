#!/usr/bin/env python3
import sys
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
    parser.add_argument('-a', '--academic', action='store_true', help='No input necessary')
    parser.add_argument('-u', '--user', help='User login name')
    parser.add_argument('-p', '--project', help='Projects info')
    parser.add_argument('-pi', '--lpi', help='PI login name')
    parser.add_argument('-v', '--v', action='store_true', help="add to -u or -p for additional info")


    #create a dictionary of all the flags, not used 
    #inputs = vars(args)  #this should automatically set the flags with no input to None

    #process the flags and print their outputs?
    #multiple inputs will only process the first one. 
    input1 = True

    #if len(sys.argv) == 1:

    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit()

    args = parser.parse_args()
    if args.academic:
        print(academic())

    for i in range(1, len(sys.argv)-1):  # Start from index 1 to skip script name
        arg = sys.argv[i]

        if arg.startswith('-'):
            if input1 == False:
                print("All secondary inputs will be ignored")

            flag = arg.lstrip('-')
            
            value = sys.argv[i+1]

            if value is not None and input1 == True:
                if flag == ('p' or 'project'):
                    print(proj(value))
                if flag == ('u' or 'user'):
                    if len(sys.argv) > (i+2):
                        if sys.argv[i+2] == '-v':
                            print(vuser_pis(value))
                    else:    
                        print(user_pis(value))
                if flag == ('pi' or 'lpi'):
                    print(pi_projs(value))
                input1 = False


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