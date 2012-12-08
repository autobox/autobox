import scipy
from numpy import resize
from scipy.io import wavfile
from scipy import signal
import numpy

kick = wavfile.read("/Users/FooYoungJim/DropBox/AutoBox/BeatBoxCorpus/snare1.wav")[1]

#mins = signal.argrelmin(kick)
#maxs = signal.argrelmax(kick)

#noise=0
#for x in range(0,1000):
#    if (maxs[0][x] - mins[0][x])<0:
#        noise=noise+ maxs[0][x] - mins[0][x]

#print noise

def extremo(n):
    extrema = signal.argrelextrema(n,numpy.add)
    old = 0
    slopesum = 0
    for x in range(1,len(extrema)):
        icur=extrema[x]
        print extrema[x]#slopesum = slopesum +(n[extrema[x]]-n[extrema[x-1]])/(extrema[x]-extrema[x-1])
        old=extrema[x]
    print slopesum

extremo(kick)
    

        
