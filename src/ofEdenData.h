//
//  ofEdenData.h
//  butterflyControl
//
//  Created by Patricio González Vivo on 01/11/11.
//  Copyright (c) 2011 PatricioGonzalezVivo.com. All rights reserved.
//

#ifndef butterflyControl_ofEdenData_h
#define butterflyControl_ofEdenData_h

#include "ofMain.h"

class ofEdenData {
public:
    
    ofEdenData(){
        maskCorners.clear();
    };
    
    int     activeLayer;
	float	topAltitude,lowAltitude;
	
	float	atmosphereCircularForce, atmosphereCircularAngle;
    float   atmosphereTempDiss, atmosphereVelDiss, atmosphereDenDiss;
	int		atmosphereResolution;
	
	float	waterLevel, absortionSoil, depresionFlow;
	float	precipitationInclination,precipitationAltitud,precipitationCold,precipitationHumidity,precipitationAmount;
	
	float	biosphereDiffU,biosphereDiffV,biosphereF,biosphereK;
    float   biosphereTimeStep, biosphereMaxDist, biosphereMinDist, biosphereMaxSpeed, biosphereMaxForce;
    float   biosphereSeparation, biosphereAlineation, biosphereCohesion;
    float   biosphereBorders;
    //float   biosphereFlat, biosphereFood;
	
	int		terrainResolution;
	
	ofPoint	center;
	float	scale;
	
    vector<ofPoint> maskCorners;
	int		maskCornersSelected;
};

#endif
