/**
 * Skeleton data class. I could not use KSkeleton because the
 * constructor has protected access. So this class can store
 * a pose but is also used as an adaptor for the currently detected
 * skeleton.
 */

class SkeletonFrame {
  final int NUM_OF_JOINTS = 26;
  final boolean DEBUG = false;
  PVector[] joints; 
  KSkeleton skel = null;
  int rightHandState = 0;
  int leftHandState = 0;

  float displayScale = 200;
  float displayZScale = 300;

  SkeletonFrame() {
  }

  /**
   * Copies data from the "live" skeleton.
   */
  SkeletonFrame(KSkeleton ks) {
    joints = new PVector[ks.getJoints().length];
    for (int i = 0; i < joints.length; i++) {
      KJoint j = ks.getJoints()[i];
      joints[i] = new PVector(j.getX(), j.getY(), j.getZ());
    }
    rightHandState = ks.getJoints()[KinectPV2.JointType_HandRight].getState();
    leftHandState = ks.getJoints()[KinectPV2.JointType_HandLeft].getState();
  }

  /**
   * Creates frame from data loaded e.g. from HD.
   */
  SkeletonFrame(String line) {
    joints = new PVector[NUM_OF_JOINTS];
    String[] parts = line.split(" ");
    int j = 0;
    int jointCount = 0;

    // joints
    for (int i = 1; i < parts.length; i++) {
      j++;
      if (j == 3) {
        joints[jointCount++] = 
          new PVector(float(parts[i-2]), float(parts[i-1]), float(parts[i]));
        j = 0;
      }
    }

    // hand states
    rightHandState = int(parts[parts.length-2]);
    leftHandState = int(parts[parts.length-1]);
  }

  /**
   * For the dummy skeleton so it can be drawn.
   */
  void setKSkeleton(KSkeleton s) {
    skel = s;
  }

  int getNumJoints() {
    return skel != null ? skel.getJoints().length : joints.length;
  }

  int getRightHandState() {
    return skel != null ? skel.getJoints()[KinectPV2.JointType_HandRight].getState() : rightHandState;
  }

  int getLeftHandState() {
    return skel != null ? skel.getJoints()[KinectPV2.JointType_HandLeft].getState() : leftHandState;
  }

  float getJointX(int index) {
    return displayScale * (skel == null ? joints[index].x : skel.getJoints()[index].getX());
  }

  float getJointY(int index) {
    return displayScale * (1-(skel == null ? joints[index].y : skel.getJoints()[index].getY()));
  }

  float getJointZ(int index) {
    return displayZScale * (1-(skel == null ? joints[index].z : skel.getJoints()[index].getZ()));
  }

  String handState(int handState) {
    switch(handState) {
    case KinectPV2.HandState_Open:
      return "open";
    case KinectPV2.HandState_Closed:
      return "closed";
    case KinectPV2.HandState_Lasso:
      return "lasso";
    case KinectPV2.HandState_NotTracked:
      return "not tracked";
    }
    return "unknown";
  }

  color handStateColor(int handState) {
    switch(handState) {
    case KinectPV2.HandState_Open:
      return #3DFA70;
    case KinectPV2.HandState_Closed:
      return #FC9069;
    case KinectPV2.HandState_Lasso:
      return #3DFA5D;
    case KinectPV2.HandState_NotTracked:
      return #00BDFF;
    }
    return #00BDFF;
  }

  void render() {
    if (DEBUG) {
      println("HandTipRight: ", getJointX(KinectPV2.JointType_HandTipRight), 
        getJointY(KinectPV2.JointType_HandTipRight), 
        getJointZ(KinectPV2.JointType_HandTipRight));
    }

    pushMatrix();
    translate(width/2, height/4, 500);
    
    drawBone(KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
    drawBone(KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
    drawBone(KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
    drawBone(KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
    drawBone(KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
    drawBone(KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
    drawBone(KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
    drawBone(KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

    drawBone(KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
    drawBone(KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
    drawBone(KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
    drawBone(KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
    drawBone(KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

    drawBone(KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
    drawBone(KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
    drawBone(KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
    drawBone(KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
    drawBone(KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

    drawBone(KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
    drawBone(KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
    drawBone(KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

    drawBone(KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
    drawBone(KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
    drawBone(KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

    drawJoint(KinectPV2.JointType_HandTipLeft, .2);
    drawJoint(KinectPV2.JointType_HandTipRight, .2);
    drawJoint(KinectPV2.JointType_FootLeft, .2);
    drawJoint(KinectPV2.JointType_FootRight, .2);

    drawJoint(KinectPV2.JointType_ThumbLeft, .2);
    drawJoint(KinectPV2.JointType_ThumbRight, .2);

    drawJoint(KinectPV2.JointType_Head);

    textSize(12);
    textAlign(LEFT);
    fill(handStateColor(getRightHandState()));
    text("R: " + handState(getRightHandState()), 
      getJointX(KinectPV2.JointType_HandRight), 
      getJointY(KinectPV2.JointType_HandRight));

    textAlign(RIGHT);
    fill(handStateColor(getLeftHandState()));
    text("L: " + handState(getLeftHandState()), 
      getJointX(KinectPV2.JointType_HandLeft)-10, 
      getJointY(KinectPV2.JointType_HandLeft));

    popMatrix();
  }

  void drawJoint(int jointType) {
    drawJoint(jointType, 1);
  }

  void drawJoint(int jointType, float sizeFactor) {
    /*
    float size = getJointZ(jointType);
     fill(0);
     stroke(255);
     strokeWeight(1);
     ellipse(getJointX(jointType), getJointY(jointType), 25, 25);
     */

    strokeWeight(5);
    stroke(255,0,0);
    point(getJointX(jointType), getJointY(jointType), getJointZ(jointType));
  }

  void drawBone(int jointType1, int jointType2) {

    stroke(255);
    strokeWeight(1);

    //line(getJointX(jointType1), getJointY(jointType1), 
    //  getJointX(jointType2), getJointY(jointType2));

    line(getJointX(jointType1), getJointY(jointType1), getJointZ(jointType1), 
      getJointX(jointType2), getJointY(jointType2), getJointZ(jointType2));

    drawJoint(jointType1);
  }

  /**
   * Returns string representation of this pose.
   */
  String serialize() {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < getNumJoints(); i++) {
      //sb.append(getJointX(i) + " " + getJointY(i) + " " + getJointZ(i) + " ");
      sb.append((skel == null ? joints[i].x : skel.getJoints()[i].getX()) + " ");
      sb.append((skel == null ? joints[i].y : skel.getJoints()[i].getY()) + " ");
      sb.append((skel == null ? joints[i].z : skel.getJoints()[i].getZ()) + " ");
    }
    sb.append(getRightHandState() + " " + getLeftHandState());
    return sb.toString();
  }
}
