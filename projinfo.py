from argparse import ArgumentParser #take in sys arg
from func.functions import proj_users, pi_projs, semester

def main():
    '''
    adding the arg parse code here!
    - use dictionary to map inputs to functions
    '''
    #create parser + define arguments
    parser = ArgumentParser(description='tool to return information about current projects and PIs') #not sure where this description will show up so idk what to put here lol
    parser.add_argument('arg1', help='function name: proj_users, pi_projs, semester')
    parser.add_argument('-o', '--optional', help='input for functions that require it: project name for proj_users, PI name for pi_projs')

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

