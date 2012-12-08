## generates train and test sets
## first arg is Feature CSV, second is Label CSV, third is number of folds

import numpy
import sys
from sklearn import cross_validation
import sklearn

folds = int(sys.argv[3])

X = numpy.loadtxt(open(sys.argv[1],"rb"),delimiter=",")
y = numpy.loadtxt(open(sys.argv[2],"rb"),delimiter=",")

kf = cross_validation.KFold(len(y),k=folds)
for train_index, test_index in kf:
    print("TRAIN: %s TEST: %s" % (train_index, test_index))
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = y[train_index], y[test_index]
