#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxOsc.h"

#include "ofEdenData.h"

#include "ofMask.h"
#include "ofButton.h"
#include "ofSlider.h"

#define SERVER_HOST "192.168.1.133"
#define SERVER_PORT 1984
#define CLIENT_PORT 1985

class testApp : public ofxiPhoneApp {
public:
    void setup();
    void update();
    void draw();
    void exit();
		
    void touchDown(ofTouchEventArgs &touch);
    void touchMoved(ofTouchEventArgs &touch);
    void touchUp(ofTouchEventArgs &touch);
    void touchDoubleTap(ofTouchEventArgs &touch);
    void touchCancelled(ofTouchEventArgs &touch);

    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);

    ofxOscSender    sender;
    ofxOscReceiver	receiver;
    string          serverHost;
    int             serverPort;
    int             clientPort;
    
    ofImage         logo;
    ofImage         fondo;
    ofImage         icons[6];
    ofImage         iconsSel[6];
    
    ofEdenData      data;
    ofButton        buttonLayers[10];
    ofButton        bSave,bReload;
    
    ofMask          mask;
    ofButton        bZoomIn,bZoomOut;
    
    ofSlider        topAlt, lowAlt;
    ofSlider        wLevel;
    ofSlider        pAlt, pAmo, pCold, pHum, pInc, aSoil, dFlow;
    ofSlider        aCirForce, aCirAngle, aTempDiss, aVelDiss, aDenDiss;
    ofSlider        vDiffU, vDiffV, vF, vK;
    ofSlider        aMaxDist, aMinDist, aMaxSpeed, aMaxForce;
    ofSlider        aSep, aAli, aCoh, aBor;
};

