from scipy.io import wavfile
import numpy

kick = wavfile.read("/Users/FooYoungJim/DropBox/AutoBox/BeatBoxCorpus/hihats1.wav")[1]
#kick = wavfile.read("kick.wav")[1]
hihat = wavfile.read("hihat.wav")[1]
snare = wavfile.read("snare.wav")[1]
kick_zc = numpy.where(numpy.diff(numpy.sign(kick)))[0]
hihat_zc = numpy.where(numpy.diff(numpy.sign(hihat)))[0]
print kick_zc
print hihat_zc


ints=[]
split_at = ints

print kick.shape
t=kick.shape[0]
print t
l=0

for x in range(0,4000000)[0::2000]:
    if abs(kick[x][0])>500 and abs(kick[x+200][0])>500  and l==0:
        ints.append(x)
        l=l+1
    else:l=0

B = numpy.split(kick, split_at)
print len(B)

for rah in B:

    zc = 0
    old = [1,1]


    for x in range(0,1000):
        row = rah[x]
        if (row[0]/old[0])<0:
            zc = zc + 1
        old = row
    print (zc)

 

  #  print float(zc)
   # print float(zcf)
   # print float(zcd)
