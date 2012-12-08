#Import the library

from midiutil.MidiFile import MIDIFile
import sys

#Create the MIDIFile Object with 1 track
MyMIDI = MIDIFile(3)

#Tracks are numbered from zero. Times are measured in beats.

track = 3
time = 0

#Add track name and tempo.

for x in range(0,track):
    MyMIDI.addTrackName(x,time,"BeatBox Test")
    MyMIDI.addTempo(x,time,80)


#parse the CSV file
f = open(sys.argv[1], "r")
#pay = f.readline()
#george = pay.strip().split(',')
#for x in range(0,len(george)):
#    print george[x]

timels = [] #row 1 of CSV
trackls = [] # row 2 of CSV
volumels = [] # row 3 of CSV


#Add a note. addNote expects the following information:

channel = 0
pitch=60
time = 0
#time2= 2.45
duration = .01
volume = 100
track = 0


#This function fills arrays with the values from the CSV
for i,row in enumerate(f):
    pay = row
    george = pay.strip().split(',')
    georgelen = len(george) 
    for x in range(0,len(george)):
        if i == 0:
            timels.append(float(george[x]))
            print timels[x]
        if i == 1:
            trackls.append(int(george[x])-1)
            print trackls[x]
        if i == 2:
            volumels.append(int(george[x]))
            print volumels[x]

        


for x in range(0,georgelen):
#    print timels[x]
#    print volumels[x]
#    print trackls[x]
    MyMIDI.addNote(trackls[x],channel,pitch,timels[x],duration,volumels[x])

#tracks = [0,2]
#print tracks[0]

#now add the note
#MyMIDI.addNote(track, channel, pitch, time, duration, volume)
#MyMIDI.addNote(track, channel, pitch, time2, duration, volume)


# And write it to disk
binfile = open("output.mid",'wb')
MyMIDI.writeFile(binfile)
binfile.close()
