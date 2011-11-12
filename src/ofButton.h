//
//  ofButton.h
//  butterflyControl
//
//  Created by Patricio González Vivo on 01/11/11.
//  Copyright (c) 2011 PatricioGonzalezVivo.com. All rights reserved.
//

#ifndef butterflyControl_ofButton_h
#define butterflyControl_ofButton_h

#include "ofMain.h"
#include "ofGuiObject.h"

class ofButton : public ofGuiObject {
public:
    
    ofButton(){
        pos.x = 0;
        pos.y = 0;
        width = 0;
        height = 0;
        selected = false;
        text = "";
        img = NULL;
        imgS = NULL;
    };
    
    ofButton(int _x, int _y, int _width, int _height){
        pos.x = _x;
        pos.y = _y;
        width = _width;
        height = _height;
        selected = false;
        text = "";
        img = NULL;
        imgS = NULL;
    };
    
    void draw(){
        ofPushMatrix();
        ofTranslate(pos.x,pos.y,0);
        
        if ( img == NULL){
            ofSetColor(255,255);
            ofNoFill();
            rBox();
            
            if (!selected){
                ofSetColor(173,255);
            } else {  
                ofSetColor(255,200);
                ofFill();
                rBox();
                ofSetColor(0,255);
            }
            
            int lengthW = text.size(); 
            ofDrawBitmapString(text, lengthW * -4 , 5 );
        } else {
            ofEnableBlendMode(OF_BLENDMODE_ADD);
            ofSetColor(255,255);
            
            if (!selected)
                img->draw(-img->getWidth()*0.5, -img->getHeight()*0.5);
            else if (imgS != NULL)
                imgS->draw(-img->getWidth()*0.5, -img->getHeight()*0.5);
            else
                img->draw(-img->getWidth()*0.5, -img->getHeight()*0.5);
            
            ofEnableBlendMode(OF_BLENDMODE_ALPHA);
            ofDisableBlendMode();
            
            ofEnableAlphaBlending();
        }
        
        ofPopMatrix();
    };
    
    void rBox(){
        float W = width * 0.5;
        float H = height * 0.5;
        
        float a = (  (H < W)? H : W ) * 0.5;
        float b = a/3;
        
        ofBeginShape(); 
        ofVertex(		W -a,	-H );
        
        ofBezierVertex( W -b ,	-H,
                       W    ,	-H +b, 
                       W    ,	-H +a);
        
        ofVertex(       W    ,	H -a);
        
        ofBezierVertex( W    ,	H -b,
                       W -b ,	H,
                       W -a ,	H);
        
        ofVertex(       -W +a , H );
        
        ofBezierVertex( -W +b , H,
                       -W    , H -b,
                       -W    , H -a );
        
        ofVertex(       -W    , -H +a );
        
        ofBezierVertex( -W    ,	-H +b,
                       -W +b , -H,
                       -W +a , -H );
        ofVertex(		W -a,	-H );
        ofEndShape();
    }
        
    ofImage     *img;
    ofImage     *imgS;
    
    string      text;
    bool        selected;
};

#endif
