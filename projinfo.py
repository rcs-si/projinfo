from argparse import ArgumentParser #take in sys arg
from func.functions import proj_users, pi_projs, semester

def parse(): #parse arguments, returns input in a dictionary
    #create parser + define arguments
    parser = ArgumentParser(description='tool to return information about current projects and PIs') #not sure where this description will show up so idk what to put here lol
    parser.add_argument('-p', '--project', help='Project name')
    parser.add_argument('-u', '--user', help='User login name')
    parser.add_argument('-s', '--semester', help='Current semesters projects')
    parser.add_argument('-pi', '--lpi', help='PI login name')

    args = parser.parse_args()

    #create a dictionary of all the flags
    flagsDict = vars(args)


    for key, value in flagsDict.items():
        if value is None:
            flagsDict[key] = None
    
    return flagsDict











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