//
//  ofSlider.h
//  butterflyControl
//
//  Created by Patricio González Vivo on 02/11/11.
//  Copyright (c) 2011 PatricioGonzalezVivo.com. All rights reserved.
//

#ifndef butterflyControl_ofSlider_h
#define butterflyControl_ofSlider_h

#include "ofMain.h"
#include "ofGuiObject.h"

class ofSlider : public ofGuiObject{
public:
    ofSlider(){
        pos.x = 0;
        pos.y = 0;
        width = 0;
        height = 0;
        value = 0;
        lnkValue = NULL;
        maxValue = 0;
        minValue = 0;
        text = "";
    }
    
    ofSlider(int _x, int _y, int _w, int _h){
        pos.x = _x;
        pos.y = _y;
        width = _w;
        height = _h;
        value = 0;
        lnkValue = NULL;
        maxValue = 0;
        minValue = 0;
        text = "";
    }
    
    void linkValue(float * _lnkValue){lnkValue = _lnkValue;};
    void setMinMax(float _minValue, float _maxValue){minValue = _minValue; maxValue = _maxValue;};
    
    void draw(){
        
        value = ((*lnkValue) - minValue) / (maxValue-minValue);
        
        ofPushMatrix();
        ofTranslate(pos.x-width*0.5, pos.y-height*0.5,0);
        ofNoFill();
        ofSetColor(255,255);
        ofRect(0,0,width,height);
        ofFill();
        ofSetColor(255,50);
        ofRect(0,0,width,height);
        ofSetColor(255,175);
        ofRect(0,0,width*value,height);
        ofPushStyle();
        string st = text+" "+ ofToString( *lnkValue );
        ofSetColor(0,255);
        ofDrawBitmapString(st, 10, 5 + height*0.5 );
        ofPopStyle();
        ofPopMatrix();
        
    }
    
    bool isOver(float _x, float _y){
        if ( (_x >= pos.x-width*0.5) && (_x <= pos.x+width*0.5) && (_y >= pos.y-height*0.5) && (_y <= pos.y+height*0.5))
            return true;
        else 
            return false;
    };
    
    void pressAndMove(float _x, float _y){
        value = ( _x - pos.x + width*0.5 ) / width;
        *lnkValue = ( value * (maxValue-minValue) ) + minValue;
    };
    
    string  text;
    float   *lnkValue;
    float   value,minValue,maxValue;
};


#endif
