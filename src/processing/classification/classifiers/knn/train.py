## generates train and test sets
## first arg is Feature CSV, second is Label CSV, third is number of folds, fourth is the number of kneighbors

import numpy
import sys
from sklearn import cross_validation
import sklearn
from sklearn.neighbors import KNeighborsClassifier
import pickle


corpusFeatures = "features/computed/mfcc20flat.csv"
corpusLabels = "corpusLabels.csv"
#Generate train and test sets
X = numpy.loadtxt(open(corpusFeatures,"rb"),delimiter=",")
y = numpy.loadtxt(open(corpusLabels,"rb"),delimiter=",")
neigh = KNeighborsClassifier(n_neighbors=3, weights='distance')
neigh.fit(X,y)
pickle.dump(neigh, open("neigh.p","wb"))





