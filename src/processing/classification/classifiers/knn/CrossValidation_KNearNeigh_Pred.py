## generates train and test sets
## first arg is Feature CSV, second is Label CSV, third is number of folds, fourth is the number of kneighbors

import numpy
import sys
from sklearn import cross_validation
import sklearn
from sklearn.neighbors import KNeighborsClassifier
import pickle

#setup for knn
folds = int(sys.argv[3])
nbors = int(sys.argv[4])

scores = [] #array for score values
scoresavg = []
scoresvar = []
diffs = []
fits = [] #array for fit values

#Generate train and test sets
X = numpy.loadtxt(open(sys.argv[1],"rb"),delimiter=",")
y = numpy.loadtxt(open(sys.argv[2],"rb"),delimiter=",")
#print y.shape


for j in range(1,15):
    neigh = KNeighborsClassifier(n_neighbors=j, weights='distance')
    kf = cross_validation.KFold(len(y),k=folds, shuffle=True)
    for train_index, test_index in kf:
        #print("TRAIN: %s TEST: %s" % (train_index, test_index))
        X_train, X_test = X[train_index], X[test_index]
        y_train, y_test = y[train_index], y[test_index]

        #generate knn analysis
        fits.append(neigh.fit(X_train,y_train))
        scores.append(neigh.score(X_test,y_test))

  #  print(scores)
    avg = float(sum(scores)/len(scores))
    for k in range(0,len(scores)):
        diffs.append((scores[k]-avg)*(scores[k]-avg))
    print diffs
   
    var = float(sum(diffs)/len(scores))   
    scoresavg.append(avg)
    scoresvar.append(var)
print(scoresavg)
print(scoresvar)

pickle.dump(neigh, open("neigh.p","wb"))



