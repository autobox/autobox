## generates train and test sets
## first arg is Feature CSV, second is Label CSV, third is number of folds, fourth is the number of kneighbors

import numpy
import sys
from sklearn import cross_validation
import sklearn
from sklearn.neighbors import KNeighborsClassifier
import pickle
import csv
import os

fits = [] #array for fit values

cname = sys.argv[1]
fname = sys.argv[2]

#Generate train and test sets
X = numpy.loadtxt(open(fname + '_features.csv', "rb"), delimiter=",")
class = pickle.load(open('/CrossValidationfname+'+cname+'.p', 'r'))
y = class.predict(X)

f = open(fname + '_labels.csv', 'w')

for yi in y:
  print yi
  f.write(str(yi) + '\n')  
f.close()
