## generates train and test sets
## first arg is Feature CSV second is number of folds

import numpy
import sys
from sklearn import cross_validation
import sklearn
from sklearn import mixture
from matplotlib.mlab import PCA
import matplotlib
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

from matplotlib.figure import Figure

#setup for knn
folds = int(sys.argv[2])


scores = [] #array for score values
scoresavg = []
scoresvar = []
diffs = []
fits = [] #array for fit values

#Generate train and test sets
X = numpy.loadtxt(open(sys.argv[1],"rb"),delimiter=",")

g = mixture.GMM(n_components=3, covariance_type='full')



kf = cross_validation.KFold(len(X),k=folds, shuffle=True)
for train_index, test_index in kf:
    #print("TRAIN: %s TEST: %s" % (train_index, test_index))
    X_train, X_test = X[train_index], X[test_index]
   

    #generate knn analysis
    fits.append(g.fit(X_train))
    scores.append(g.bic(X_test))
print scores

fig = Figure(figsize=(6,6))
canvas = FigureCanvas(fig)
myPCA = PCA(X)
pcDataPoint = myPCA.project(X)
ax = fig.add_subplot(111)
ax.scatter(pcDataPoint[:,1],pcDataPoint[:,2])
canvas.print_figure("PCA12.png",dpi=500)
#  print(scores)
#avg = float(sum(scores)/len(scores))
#for k in range(0,len(scores)):
#    diffs.append((scores[k]-avg)*(scores[k]-avg))
#print diffs

#var = float(sum(diffs)/len(scores))   
#scoresavg.append(avg)
#scoresvar.append(var)
#print(scoresavg)
#print(scoresvar)



