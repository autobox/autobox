## generates train and test sets
## first arg is Feature CSV, second is Label CSV, third is number of folds, fourth is the number of kneighbors

import numpy
import sys
from sklearn import cross_validation
import sklearn
from sklearn.neighbors import KNeighborsClassifier
import pickle

#k values to try:
ks=[3,10,1]

for feature in range(1,5):
    corpusFeatures = "Features/f" + str(feature) + ".csv"
    corpusLabels = "corpusLabels.csv"
    #Generate train and test sets
    X = numpy.loadtxt(open(corpusFeatures,"rb"),delimiter=",")
    y = numpy.loadtxt(open(corpusLabels,"rb"),delimiter=",")
    for classifier in range(0,3):
        neigh = KNeighborsClassifier(n_neighbors=ks[classifier], weights='distance')
        neigh.fit(X,y)
        pickle.dump(neigh, open("c" + str(classifier) + "f" + str(feature) + ".p","wb"))





