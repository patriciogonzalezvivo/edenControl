//
//  ofMask.h
//  butterflyControl
//
//  Created by Patricio González Vivo on 01/11/11.
//  Copyright (c) 2011 PatricioGonzalezVivo.com. All rights reserved.
//

#ifndef butterflyControl_ofMask_h
#define butterflyControl_ofMask_h

#include "ofMain.h"
#include "ofEdenData.h"
#include "ofGuiObject.h"

class ofMask : public ofGuiObject {
public:
    ofMask(){
        data = NULL;
        width = 640;
        height = 480;
        pos.x = 0;
        pos.y = 0;
        pointSize = width*0.03;
    }
    
    ofMask(int _x, int _y, int _width, int _height){
        data = NULL;
        width = _width;
        height = _height;
        pos.x = _x;
        pos.y = _y;
        pointSize = width / 64;
    }
    
    void setData(ofEdenData * _data){data = _data;};
    
    void draw(){
        //ofFill();
        //ofSetColor(0,200);
        //ofRect(0, 0, 1024, 768);
        
        ofPushMatrix();
        ofTranslate(pos.x,pos.y,0);
    
        // CALIBRATION
        ofPushMatrix();
        ofScale(data->scale, data->scale);
        ofSetColor(255,50);
        ofNoFill();
        ofRect(-width*0.5 + data->center.x * width , 
               -height*0.5 + data->center.y * height, 
               width, height);
        ofFill();
        ofCircle( -25 + (data->center.x * width) , -25 + (data->center.y * height) , 50);
        ofPopMatrix();
        
        // BORDER
        ofTranslate(-width*0.5,-height*0.5,0);
        ofFill();
        ofSetColor(0,100);
    
        ofBeginShape();
        for(int i = 0; i < data->maskCorners.size(); i++){
            ofNoFill();
            if ( data-> maskCornersSelected == i)
                ofFill();
            else
                ofNoFill();
            
            ofPushStyle();
            ofSetColor(255,200);
            ofCircle(data->maskCorners[i].x * width, data->maskCorners[i].y * height, pointSize);
            ofPopStyle();
            
            ofSetColor(255,255);
            ofNoFill();
            ofVertex(data->maskCorners[i].x * width, data->maskCorners[i].y * height);
        }
        ofEndShape(true);
        
        ofPopMatrix();
    }
    
    void pointPress(float _x, float _y){
        int x = (_x - (pos.x-width*0.5));
        int y = (_y - (pos.y-height*0.5));
		for(int i = 0; i < data->maskCorners.size(); i++){
			if ( ofDist(x, y, data->maskCorners[i].x * width, data->maskCorners[i].y*height) <= pointSize ){
				data->maskCornersSelected = i;
            }
		}
    };
    
    int pointMove(float _x, float _y){
        if ( data->maskCornersSelected != -1 ) {
            int x = (_x - (pos.x-width*0.5));
            int y = (_y - (pos.y-height*0.5));
            
            data->maskCorners[data->maskCornersSelected].x = (float) (x/(float)width);
            data->maskCorners[data->maskCornersSelected].y = (float) (y/(float)height);
        }
        return data->maskCornersSelected;
    };
    
    void pointRelease(){
        if (data->maskCornersSelected != -1)
			data->maskCornersSelected = -1;
    };
    
    bool calibBoxPressed(float _x, float _y){
        float scaledW = width;// * data->scale;
        float scaledH = height;// * data->scale;
        
        float x = _x - pos.x - (data->center.x * scaledW); 
        float y = _y - pos.y - (data->center.y * scaledH);
        
        //if ( (x >= -scaledW * 0.5 ) && (x <=  scaledW * 0.5) && (y >= -scaledH * 0.5) && (y <=  scaledH * 0.5 ) )
        if ( ofDist(x, y, 0, 0) < 50)
            return true;
        else 
            return false;
    };
    
    void calibBoxDragged(float _x, float _y){
        float x = _x - pos.x;
        float y = _y - pos.y;
        
        data->center.x = (x / width);//  * data->scale;
        data->center.y = (y / height);// * data->scale;
    }
    
private:
    ofEdenData  *data;
    int         pointSize;
};

#endif
