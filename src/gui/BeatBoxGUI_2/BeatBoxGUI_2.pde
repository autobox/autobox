import ddf.minim.*;

Minim minim;
AudioInput in;
AudioRecorder recorder;

void setup()
{
  size(512, 200);





  minim = new Minim(this);

  // get a stereo line-in: sample buffer length of 512
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);
  // create a recorder that will record from the input
  // to the filename specified, using buffered recording
  // buffered recording means that all captured audio
  // will be written into a sample buffer
  // then when save() is called, the contents of the buffer
  // will actually be written to a file
  // the file will be located in the sketch's root folder.
  recorder = minim.createRecorder(in, "myrecording.wav", true);

  textFont(createFont("Arial", 12));
}

void draw()
{
  background(0);
  stroke(255);
  for (int i = 0; i < in.left.size()-1; i++)
  {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }

  if ( recorder.isRecording() )
  {
    text("Currently recording...", 5, 15);
  }
  else
  {
    text("Not recording.", 5, 15);
  }
}

void keyReleased()
{
  if ( key == 'r' )
  {
    if ( recorder.isRecording() )
    {
      recorder.endRecord();
    }
    else
    {
      recorder.beginRecord();
    }
  }
  if ( key == 's' )
  {
    recorder.save();
    println("Done saving.");
  }
  if (key == 'a')
  {execute();}
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
}    


void execute() {

  String commandToRun = "sh wav2midi.sh myrecording.wav";
  File workingDir = new File("/Users/snikolov/Projects/BeatBox/");   // where to do it - should be full path
  String returnedValues;                                                                     // value to return any results

    // give us some info:
  println("Running command: " + commandToRun);
  println("Location:        " + workingDir);
  println("---------------------------------------------\n");

  // run the command!
  try {

    // complicated!  basically, we have to load the exec command within Java's Runtime
    // exec asks for 1. command to run, 2. null which essentially tells Processing to 
    // inherit the environment settings from the current setup (I am a bit confused on
    // this so it seems best to leave it), and 3. location to work (full path is best)
    Process p = Runtime.getRuntime().exec(commandToRun, null, workingDir);

    // variable to check if we've received confirmation of the command
    int i = p.waitFor();

    // if we have an output, print to screen
    if (i == 0) {

      // BufferedReader used to get values back from the command
      BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

      // read the output from the command
      while ( (returnedValues = stdInput.readLine ()) != null) {
        println(returnedValues);
      }
    }

    // if there are any error messages but we can still get an output, they print here
    else {
      BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));

      // if something is returned (ie: not null) print the result
      while ( (returnedValues = stdErr.readLine ()) != null) {
        println(returnedValues);
      }
    }
  }

  // if there is an error, let us know
  catch (Exception e) {
    println("Error running command!");  
    println(e);
  }

  // when done running command, quit
  println("\n---------------------------------------------");
  println("DONE!");
 // exit();
}


//sh wavtomidi.sh myrecording.wav

