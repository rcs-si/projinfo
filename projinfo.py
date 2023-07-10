'''
i dont think i need this actually but ill leave it here j in case
'''

from argparse import ArgumentParser
import pandas as pd

parser = ArgumentParser(description='hello')

user_df = pd.read_csv('projuser.csv')
pi_df = pd.read_csv('pidb.csv')

user_labels = ['proj', 'user', 'date']
user_df.columns = user_labels

#print(pi_df.tail(10))
#print(user_df.tail(10))
#projname = str(sys.argv[1])

