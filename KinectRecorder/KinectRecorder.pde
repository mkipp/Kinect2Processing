/**
 * (c) 2018 Michael Kipp
 * http://michaelkipp.de
 *
 * Requires KinectPV2 library by Thomas Lengeling
 */

import KinectPV2.*;

KinectPV2 kinect;
ArrayList<SkeletonFrame> recording = new ArrayList<SkeletonFrame>();
boolean isRecording = false;
boolean isPlaying = false;
int playbackFrame = 0;
SkeletonFrame dummyFrame = new SkeletonFrame(); // contains "live" skeleton for drawing

boolean showColorImage = false;

void setup() {
  size(1920, 1080, P3D);
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(showColorImage);
  kinect.init();
}

void draw() {
  background(0);

  if (showColorImage) {
    image(kinect.getColorImage(), 0, 0, width, height);
  }

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  if (isPlaying) {
    if (playbackFrame < recording.size()) {
      println("PLAY " + playbackFrame);
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
          println("REC");
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
  text("ENTER: Start/stop recording   SPACE: Play/pause", 50, 50);
  text(int(frameRate) + " fps", 50, height-50);


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

void keyPressed() {
  if (keyCode == ENTER) {
    isRecording = !isRecording;
    if (isRecording) {
      recording.clear();
    }
  }
  if (key == ' ') {
    isPlaying = !isPlaying;
  }
}
