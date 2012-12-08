## generates train and test sets
## first arg is Feature CSV, second is Label CSV, third is number of folds, fourth is the number of kneighbors

import numpy
import sys
from sklearn import cross_validation
import sklearn
from sklearn.neighbors import KNeighborsClassifier

#setup for knn
folds = int(sys.argv[3])
nbors = int(sys.argv[4])
neigh = KNeighborsClassifier(n_neighbors=nbors)
scores = [] #array for score values
fits = [] #array for fit values

#Generate train and test sets
X = numpy.loadtxt(open(sys.argv[1],"rb"),delimiter=",")
y = numpy.loadtxt(open(sys.argv[2],"rb"),delimiter=",")
print y.shape

kf = cross_validation.KFold(len(y),k=folds, shuffle=True)
for train_index, test_index in kf:
    print("TRAIN: %s TEST: %s" % (train_index, test_index))
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = y[train_index], y[test_index]

    #generate knn analysis
    fits.append(neigh.fit(X_train,y_train))
    scores.append(neigh.score(X_test,y_test))

print(scores)



