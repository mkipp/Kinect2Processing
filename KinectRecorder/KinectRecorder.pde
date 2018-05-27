/**
 * (c) 2018 Michael Kipp
 * http://michaelkipp.de
 *
 * Requires KinectPV2 library by Thomas Lengeling
 *
 * When saved, data is stored in file called "recording.txt" in the
 * directory of this sketch
 */

import KinectPV2.*;

KinectPV2 kinect;
ArrayList<SkeletonFrame> recording = new ArrayList<SkeletonFrame>();
boolean isRecording = false;
boolean isPlaying = false;
int playbackFrame = 0;
SkeletonFrame dummyFrame = new SkeletonFrame(); // contains "live" skeleton for drawing

boolean showColorImage = false;
String toastMessage = "";
int toastTimeout = 0;

void setup() {
  size(1920, 1080, P3D);
  kinect = new KinectPV2(this);
  //kinect.enableSkeletonColorMap(true);
  kinect.enableSkeleton3DMap(true);
  kinect.enableColorImg(showColorImage);
  kinect.init();
}

void draw() {
  background(0);

  if (showColorImage) {
    image(kinect.getColorImage(), 0, 0, width, height);
  }

  //ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();

  if (isPlaying) {
    if (playbackFrame < recording.size()) {
      recording.get(playbackFrame).render();
      playbackFrame++;
    } else {
      playbackFrame = 0;
    }
  } else {
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if (skeleton.isTracked()) {
        if (isRecording) {
          recording.add(new SkeletonFrame(skeleton));
        }
        KJoint[] joints = skeleton.getJoints();

        //color col  = skeleton.getIndexColor();
        fill(255);
        stroke(255);
        dummyFrame.setKSkeleton(skeleton);
        dummyFrame.render();
      }
    }
  }

  fill(180);
  textSize(30);
  textAlign(LEFT);
  text("ENTER: Start/stop recording   SPACE: Play/pause   S: Save   L: Load", 50, 50);
  text(int(frameRate) + " fps", 50, height-50);

  // show toast message
  if (toastTimeout > 0) {
    textAlign(RIGHT);
    textSize(50);
    fill(#FFD034);
    text(toastMessage, width-50, height-50);
    toastTimeout--;
  }

  textSize(50);
  textAlign(RIGHT);
  if (isRecording) {
    fill(#FF8185);
    text("REC", width-50, 70);
    text(""+recording.size(), width-50, height-50);
  } else if (isPlaying) {
    fill(#5EFC4A);
    text("PLAY", width-50, 70);
    text(""+playbackFrame, width-50, height-50);
  } else {
    fill(#61BFFC);
    text("LIVE", width-50, 70);
  }
}

void saveRecording() {
  if (recording.size() > 0) {
    String[] data = new String[recording.size() + 2];
    data[0] = "# Kinect 2 Recording, " + recording.size() + " frames";
    data[1] = "# Date: " + day() + "/" + month() + "/" + year() +
      " " + hour() + ":" + minute() + ":" + second();
    int i = 2;
    int frame = 0;
    for (SkeletonFrame s : recording) {
      data[i] = frame + " " + s.serialize();
      i++;
      frame++;
    }
    saveStrings("recording.txt", data);
    toastMessage = "RECORDING SAVED";
    toastTimeout = 200;
  }
}

void loadRecording() {
  recording.clear();
  String[] data = loadStrings("recording.txt");
  for (int i = 2; i < data.length; i++) {
    recording.add(new SkeletonFrame(data[i]));
  }
  toastMessage = "RECORDING LOADED";
  toastTimeout = 200;
}

void keyPressed() {
  if (keyCode == ENTER) {
    isRecording = !isRecording;
    if (isRecording) {
      recording.clear();
    }
  }
  if (key == ' ') {
    isPlaying = !isPlaying;
  } else if (key == 's') {
    saveRecording();
  } else if (key == 'l') {
    loadRecording();
    isPlaying = true;
  }
}
