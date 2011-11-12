//
//  ofGuiObject.h
//  butterflyControl
//
//  Created by Patricio González Vivo on 03/11/11.
//  Copyright (c) 2011 PatricioGonzalezVivo.com. All rights reserved.
//

#ifndef butterflyControl_ofGuiObject_h
#define butterflyControl_ofGuiObject_h

#include "ofMain.h"

class ofGuiObject{
public:
    
    ofGuiObject(){
        pos.x = 0;
        pos.y = 0;
        width = 0;
        height = 0;
    };
    
    virtual void draw(){};
        
    bool isOver(float _x, float _y){
        if ( (_x <= pos.x+width*0.5) && (_x >= pos.x-width*0.5) && (_y <= pos.y+height*0.5) && (_y >= pos.y-height*0.5))
            return true;
        else 
            return false;
    };
    
    ofVec2f     pos;
    int         width,height;
};



#endif
