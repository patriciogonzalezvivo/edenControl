#include "testApp.h"

#include "MyGuiView.h"

MyGuiView * myGuiViewController;

//--------------------------------------------------------------
void testApp::setup(){
	ofRegisterTouchEvents(this);
	ofxAccelerometer.setup();
	ofxiPhoneAlerts.addListener(this);
    ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    ofEnableSmoothing();
    ofSetCurveResolution(20);
    
    serverHost  = SERVER_HOST;
	serverPort  = SERVER_PORT;
	clientPort  = CLIENT_PORT;
    
    sender.setup(serverHost, serverPort);
    receiver.setup(CLIENT_PORT);
    
    logo.loadImage("logo.png");
    fondo.loadImage("info.png");
    
    
    data.activeLayer = -1;
    data.lowAltitude = 500;
    data.topAltitude = 500;
    data.atmosphereTempDiss = 0.75;
    data.atmosphereDenDiss = 0.75;
    data.atmosphereVelDiss = 0.75;
    data.scale = 1;
    data.center.x = 0;
    data.center.y = 0;
    
    int size = 50;
    int spaceBtw = 20;
    
    int width = 1024;
    int widthLeft = width - size - spaceBtw - spaceBtw * 0.5;
    int widthLeftCenter = size*0.5 + spaceBtw*0.5 + width*0.5;
    
    // LAYERS BUTTONS
    for (int i = 1; i < 11; i++){
        buttonLayers[(i%10)] = ofButton(spaceBtw*0.5+size*0.5, spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*i , size, size);
        buttonLayers[(i%10)].text = ofToString( i%10 );
    }
    
    for (int i = 0; i < 6; i++){
        string fileName = ofToString(i)+".png";
        icons[i].loadImage(fileName);
        
        fileName = ofToString(i)+"s.png";
        iconsSel[i].loadImage(fileName);
    }
    
    buttonLayers[0].img = &(icons[5]);
    buttonLayers[1].img = &(icons[0]);
    buttonLayers[2].img = &(icons[0]);
    buttonLayers[3].img = &(icons[0]);
    buttonLayers[4].img = &(icons[0]);
    buttonLayers[5].img = &(icons[0]);
    buttonLayers[6].img = &(icons[1]);
    buttonLayers[7].img = &(icons[2]);
    buttonLayers[8].img = &(icons[3]);
    buttonLayers[9].img = &(icons[4]);
    
    buttonLayers[0].imgS = &(iconsSel[5]);
    buttonLayers[1].imgS = &(iconsSel[0]);
    buttonLayers[2].imgS = &(iconsSel[0]);
    buttonLayers[3].imgS = &(iconsSel[0]);
    buttonLayers[4].imgS = &(iconsSel[0]);
    buttonLayers[5].imgS = &(iconsSel[0]);
    buttonLayers[6].imgS = &(iconsSel[1]);
    buttonLayers[7].imgS = &(iconsSel[2]);
    buttonLayers[8].imgS = &(iconsSel[3]);
    buttonLayers[9].imgS = &(iconsSel[4]);
    
    bReload = ofButton(width - spaceBtw*0.5 - size, spaceBtw*0.5 + size*0.5, size*2, size*0.6);
    bReload.text = "Reload";
    bSave = ofButton(width - spaceBtw*0.5 - size - spaceBtw*0.5 - size*2 , spaceBtw*0.5 + size*0.5, size*2, size*0.6);
    bSave.text = "Save";
    
    bZoomIn = ofButton(widthLeftCenter - spaceBtw*0.5 - size*0.5, spaceBtw*0.5 + size*0.5, size, size);
    bZoomIn.text = "+";
    bZoomOut = ofButton(widthLeftCenter + spaceBtw*0.5 + size*0.5, spaceBtw*0.5 + size*0.5, size, size);
    bZoomOut.text = "-";
    
    // MASK
    mask = ofMask(widthLeftCenter, spaceBtw*0.5 + size*0.5 + 768*0.5, widthLeft, 680);
    mask.setData(&data);
    
    // ALTITUDES
    topAlt = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + size + spaceBtw, widthLeft, size );
    topAlt.linkValue( &data.topAltitude );
    topAlt.setMinMax(500, 1000);
    topAlt.text = "Top Altitude";
    
    lowAlt = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*2, widthLeft, size );
    lowAlt.linkValue( &data.lowAltitude );
    lowAlt.setMinMax(500, 2000);
    lowAlt.text = "Low Altitude";
    
    // WATER LEVEL
    wLevel = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*3, widthLeft, size );
    wLevel.linkValue( &data.waterLevel );
    wLevel.setMinMax(0, 1.0);
    wLevel.text = "Water Level";
    
    // HYDROSPHERE
    aSoil = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*4, widthLeft, size );
    aSoil.linkValue( &data.absortionSoil );
    aSoil.setMinMax(0, 1.0);
    aSoil.text = "Soil absortion";
    
    dFlow = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*5, widthLeft, size );
    dFlow.linkValue( &data.depresionFlow);
    dFlow.setMinMax(0, 1.0);
    dFlow.text = "Water flow on depresions";
    
    pAmo = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*6, widthLeft, size );
    pAmo.linkValue( &data.precipitationAmount );
    pAmo.setMinMax(0, 2.0);
    pAmo.text = "Amount of water on precipitations";
    
    pHum = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*7, widthLeft, size );
    pHum.linkValue( &data.precipitationHumidity );
    pHum.setMinMax(0, 1.0);
    pHum.text = "Min humidity for precipitation";
    
    pCold = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*8, widthLeft, size );
    pCold.linkValue( &data.precipitationCold );
    pCold.setMinMax(0, 1.0);
    pCold.text = "Min coldness for precipitation";
    
    pInc = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*9, widthLeft, size );
    pInc.linkValue( &data.precipitationInclination );
    pInc.setMinMax(0, 1.0);
    pInc.text = "Min inclination for precipitation";
    
    pAlt = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*10, widthLeft, size );
    pAlt.linkValue( &data.precipitationAltitud );
    pAlt.setMinMax(0, 1.0);
    pAlt.text = "Min altitude for precipitation";
    
    // ATMOSHPHERE
    aCirForce = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*1, widthLeft, size );
    aCirForce.linkValue( &data.atmosphereCircularForce );
    aCirForce.setMinMax(0, 1.0);
    aCirForce.text = "Circular Wind Force";
    
    aCirAngle = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*2, widthLeft, size );
    aCirAngle.linkValue( &data.atmosphereCircularAngle);
    aCirAngle.setMinMax(0, -90.0);
    aCirAngle.text = "Circular Wind Angle";
    
    aTempDiss = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*3, widthLeft, size );
    aTempDiss.linkValue( &data.atmosphereTempDiss);
    aTempDiss.setMinMax(0.75, 1.0);
    aTempDiss.text = "Temperature Dissipation";
    
    aDenDiss = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*4, widthLeft, size );
    aDenDiss.linkValue( &data.atmosphereDenDiss);
    aDenDiss.setMinMax(0.75, 1.0);
    aDenDiss.text = "Density Dissipation";
    
    aVelDiss = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*5, widthLeft, size );
    aVelDiss.linkValue( &data.atmosphereVelDiss);
    aVelDiss.setMinMax(0.75, 1.0);
    aVelDiss.text = "Velocity Dissipation";
    
    // BIOSPHERE -> VEGETAL
    vDiffU = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*4, widthLeft, size );
    vDiffU.linkValue( &data.biosphereDiffU);
    vDiffU.setMinMax(0, 0.5);
    vDiffU.text = "Diff U";
    
    vDiffV = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*5, widthLeft, size );
    vDiffV.linkValue( &data.biosphereDiffV);
    vDiffV.setMinMax(0, 0.5);
    vDiffV.text = "Diff V";
    
    vF = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*6, widthLeft, size );
    vF.linkValue( &data.biosphereF);
    vF.setMinMax(0, 0.5);
    vF.text = "F";
    
    vK = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*7, widthLeft, size );
    vK.linkValue( &data.biosphereK);
    vK.setMinMax(0, 0.5);
    vK.text = "K";
    
    // BIOSPHERE -> ANIMAL
    aMinDist = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*1, widthLeft, size );
    aMinDist.linkValue( &data.biosphereMinDist);
    aMinDist.setMinMax(0, 0.3);
    aMinDist.text = "Min distance between boids";
    
    aMaxDist = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*2, widthLeft, size );
    aMaxDist.linkValue( &data.biosphereMaxDist);
    aMaxDist.setMinMax(0, 0.3);
    aMaxDist.text = "Max distance between boids";
    
    aMaxSpeed = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*3, widthLeft, size );
    aMaxSpeed.linkValue( &data.biosphereMaxSpeed );
    aMaxSpeed.setMinMax(0, 6.0);
    aMaxSpeed.text = "Max speed";
    
    aMaxForce = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*4, widthLeft, size );
    aMaxForce.linkValue( &data.biosphereMaxForce );
    aMaxForce.setMinMax(0, 0.1);
    aMaxForce.text = "Max Force";
    
    aSep = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*5, widthLeft, size );
    aSep.linkValue( &data.biosphereSeparation);
    aSep.setMinMax(0, 3.0);
    aSep.text = "Separation force";
    
    aAli = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*6, widthLeft, size );
    aAli.linkValue( &data.biosphereAlineation);
    aAli.setMinMax(0, 3.0);
    aAli.text = "Alineation force";
    
    aCoh = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*7, widthLeft, size );
    aCoh.linkValue( &data.biosphereCohesion);
    aCoh.setMinMax(0, 3.0);
    aCoh.text = "Cohesion force";
    
    aBor = ofSlider( widthLeftCenter , spaceBtw*0.5 + size*0.5 + (size + spaceBtw)*8, widthLeft, size );
    aBor.linkValue( &data.biosphereBorders);
    aBor.setMinMax(0, 1.0);
    aBor.text = "Avoid borders force";
    
    //Our Gui setup
	myGuiViewController	= [[MyGuiView alloc] initWithNibName:@"MyGuiView" bundle:nil];
	[ofxiPhoneGetUIWindow() addSubview:myGuiViewController.view];
	myGuiViewController.view.hidden = FALSE;
}

//--------------------------------------------------------------
void testApp::update(){
    while( receiver.hasWaitingMessages() ){
		ofxOscMessage inM;
		receiver.getNextMessage( &inM );
        
		if ( inM.getAddress() == "/points" ){
            data.maskCorners.clear();
            int totalMaskCorners = inM.getArgAsInt32(0);
            for(int i = 0; i < totalMaskCorners; i++){
                ofPoint p;
                p.set(0,0);
                data.maskCorners.push_back(p);
            }
        } else if ( inM.getAddress() == "/point" ){
            int index = inM.getArgAsInt32(0);
            
            float x = inM.getArgAsFloat(1);
            float y = inM.getArgAsFloat(2);
            
            data.maskCorners[index].x = x;
            data.maskCorners[index].y = y;
        } else if ( inM.getAddress() == "/activelayer" ){
            data.activeLayer = inM.getArgAsInt32(0);
        } else if ( inM.getAddress() == "/altitudes" ){
            data.topAltitude = inM.getArgAsInt32(0);
            data.lowAltitude = inM.getArgAsInt32(1);
        } else if ( inM.getAddress() == "/waterlevel" ){
            data.waterLevel = inM.getArgAsFloat(0);
        }  else if ( inM.getAddress() == "/hydrosphere" ){
            data.precipitationAltitud = inM.getArgAsFloat( 0 );
            data.precipitationAmount = inM.getArgAsFloat( 1 );
            data.precipitationCold = inM.getArgAsFloat( 2 );
            data.precipitationHumidity = inM.getArgAsFloat( 3 );
            data.precipitationInclination = inM.getArgAsFloat( 4 );
            data.absortionSoil = inM.getArgAsFloat( 5 );
            data.depresionFlow = inM.getArgAsFloat( 6 );
        } else if ( inM.getAddress() == "/atmosphere" ){
            data.atmosphereCircularForce = inM.getArgAsFloat( 0 );
            data.atmosphereCircularAngle = inM.getArgAsFloat( 1 );
            data.atmosphereVelDiss = inM.getArgAsFloat( 2 );
            data.atmosphereTempDiss = inM.getArgAsFloat( 3 );
            data.atmosphereDenDiss = inM.getArgAsFloat( 4 );
        } else if ( inM.getAddress() == "/vegetal" ){
            data.biosphereDiffU = inM.getArgAsFloat( 0 );
            data.biosphereDiffV = inM.getArgAsFloat( 1 );
            data.biosphereF = inM.getArgAsFloat( 2 );
            data.biosphereK = inM.getArgAsFloat( 3 );
        } else if ( inM.getAddress() == "/animal" ){
            data.biosphereMinDist = inM.getArgAsFloat( 0 );
            data.biosphereMaxDist = inM.getArgAsFloat( 1 );
            data.biosphereMaxSpeed = inM.getArgAsFloat( 2 );
            data.biosphereMaxForce = inM.getArgAsFloat( 3 );
            data.biosphereBorders = inM.getArgAsFloat( 4 );
            data.biosphereSeparation = inM.getArgAsFloat( 5 );
            data.biosphereAlineation = inM.getArgAsFloat( 6 );
            data.biosphereCohesion = inM.getArgAsFloat( 7 );
        } else if ( inM.getAddress() == "/calibration"){
            data.center.x = inM.getArgAsFloat( 0 );
            data.center.y = inM.getArgAsFloat( 1 );
            data.scale = inM.getArgAsFloat( 2 );
            
            data.center.x *= -data.scale;
            data.center.y *= -data.scale;
            data.scale = 1/data.scale;
            
        }
            
	}
	
}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(0);
    
    if (data.activeLayer == -1)
        ofSetColor(255,255);
    else 
        ofSetColor(255,50);
    
    fondo.draw(0,0);
    
    ofSetColor(255,255);
    logo.draw(10,10,50,50);
    ofDrawBitmapString("PatricioGonzalezVivo.com", 80,59);
    bSave.draw();
    bReload.draw();
    for (int i = 0; i < 10; i++){
        if (data.activeLayer == i)
            buttonLayers[i].selected = true;
        else
            buttonLayers[i].selected = false;
        
        buttonLayers[i].draw();
    }
    
    if (data.activeLayer == 0){
        mask.draw();
        bZoomIn.draw();
        bZoomOut.draw();
    } 
    
    if ((data.activeLayer > 0) && (data.activeLayer <= 5)){
        topAlt.draw();
        lowAlt.draw();
    }
    
    if ((data.activeLayer >= 5) && (data.activeLayer <= 7))
        wLevel.draw();
    
    if (data.activeLayer == 6){
        aSoil.draw();
        dFlow.draw();
    }
    
    if ((data.activeLayer == 6) || (data.activeLayer == 9) ){
        pAlt.draw();
        pAmo.draw();
        pCold.draw();
        pHum.draw();
        pInc.draw();
    }
    
    if ( data.activeLayer == 7){
        vDiffU.draw();
        vDiffV.draw();
        vF.draw();
        vK.draw();
    }
    
    if ( data.activeLayer == 8){
        aMinDist.draw();
        aMaxDist.draw();
        aMaxSpeed.draw();
        aMaxForce.draw();
        aSep.draw();
        aAli.draw();
        aCoh.draw();
        aBor.draw();
    }
    
    if (data.activeLayer == 9){
        aCirForce.draw();
        aCirAngle.draw();
        aTempDiss.draw();
        aDenDiss.draw();
        aVelDiss.draw();
    }

}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
    if ( (data.activeLayer == 0) && mask.isOver(touch.x,touch.y)){
        mask.pointPress(touch.x,touch.y);
    } 
    
    for (int i = 0; i < 10; i++){
        if (buttonLayers[i].isOver(touch.x,touch.y)){
            if (data.activeLayer != i){
                data.activeLayer = i;
                
                ofxOscMessage changeLayerMessage;
                changeLayerMessage.setAddress("/set/layer");
                changeLayerMessage.addIntArg(i);
                sender.sendMessage( changeLayerMessage );
                myGuiViewController.view.hidden = TRUE;
                
                if (i == 0){
                    ofxOscMessage getPointsMessage;
                    getPointsMessage.setAddress("/get/points");
                    sender.sendMessage( getPointsMessage );
                    
                    ofxOscMessage getCenterMessage;
                    getCenterMessage.setAddress("/get/calibration");
                    sender.sendMessage( getCenterMessage );
                    
                } else {
                    
                    if ((i > 0) && (i <= 5)){
                        ofxOscMessage outMessage;
                        outMessage.setAddress("/get/altitudes");
                        sender.sendMessage( outMessage );
                    } 
                
                    if ((data.activeLayer >= 5) && (data.activeLayer <= 7)){
                        ofxOscMessage outMessage;
                        outMessage.setAddress("/get/waterlevel");
                        sender.sendMessage( outMessage );
                    }
                    
                    if ((i == 6 ) || (i == 9)) {
                        ofxOscMessage outMessage;
                        outMessage.setAddress("/get/hydrosphere");
                        sender.sendMessage( outMessage );
                    }
                    
                    if (i == 7){
                        ofxOscMessage outMessage;
                        outMessage.setAddress("/get/vegetal");
                        sender.sendMessage( outMessage );
                    }
                    
                    if (i == 8){
                        ofxOscMessage outMessage;
                        outMessage.setAddress("/get/animal");
                        sender.sendMessage( outMessage );
                    }
                    
                    if (i == 9){
                        ofxOscMessage outMessage;
                        outMessage.setAddress("/get/atmosphere");
                        sender.sendMessage( outMessage );
                    }
                    
                    
                }
            }
        }
    }
    
    if (bSave.isOver(touch.x, touch.y)){
        ofxOscMessage outMessage;
        outMessage.setAddress("/save");
        sender.sendMessage( outMessage );
    } else if (bReload.isOver(touch.x, touch.y)){
        ofxOscMessage outMessage;
        outMessage.setAddress("/reload");
        sender.sendMessage( outMessage );
    } else if (( touch.x < 75 ) && ( touch.y < 75 )){
        data.activeLayer = -1;
        //myGuiViewController.view.hidden = FALSE;
    }
    
    if (data.activeLayer == 0){
        if (bZoomIn.isOver(touch.x, touch.y)){
            data.scale -= 0.001;
            ofxOscMessage changeScaleMessage;
            changeScaleMessage.setAddress("/set/scale");
            changeScaleMessage.addFloatArg( 1 / data.scale);
            sender.sendMessage( changeScaleMessage );
        }
        
        if (bZoomOut.isOver(touch.x, touch.y)){
            data.scale += 0.001;
            ofxOscMessage changeScaleMessage;
            changeScaleMessage.setAddress("/set/scale");
            changeScaleMessage.addFloatArg( 1 / data.scale);
            sender.sendMessage( changeScaleMessage );
        }
    }
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	if ( (data.activeLayer == 0) && mask.isOver(touch.x,touch.y)){
        mask.pointMove(touch.x,touch.y);
        
        if (data.maskCornersSelected != -1){
            ofxOscMessage changePointMessage;
            changePointMessage.setAddress("/set/point");
            changePointMessage.addIntArg(data.maskCornersSelected);
            changePointMessage.addFloatArg(data.maskCorners[data.maskCornersSelected].x);
            changePointMessage.addFloatArg(data.maskCorners[data.maskCornersSelected].y);
            sender.sendMessage( changePointMessage );
        } else if ( mask.calibBoxPressed(touch.x, touch.y) ){
            mask.calibBoxDragged(touch.x, touch.y);
            ofxOscMessage changeCenterMessage;
            changeCenterMessage.setAddress("/set/center");
            changeCenterMessage.addFloatArg(data.center.x * -data.scale);
            changeCenterMessage.addFloatArg(data.center.y * -data.scale);
            sender.sendMessage( changeCenterMessage );
        }
    } 
    
    if ((data.activeLayer > 0) && (data.activeLayer <= 5)){
        
        if (topAlt.isOver(touch.x, touch.y)){
            topAlt.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeTopAltMessage;
            changeTopAltMessage.setAddress("/set/topaltitud");
            changeTopAltMessage.addIntArg( (int)data.topAltitude);
            sender.sendMessage( changeTopAltMessage );
        }
        
        if (lowAlt.isOver(touch.x, touch.y)){
            lowAlt.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeLowAltMessage;
            changeLowAltMessage.setAddress("/set/lowaltitud");
            changeLowAltMessage.addIntArg( (int)data.lowAltitude);
            sender.sendMessage( changeLowAltMessage );
        }
    } 
    
    if ((data.activeLayer >= 5) && (data.activeLayer <= 7)){
        
        if (wLevel.isOver(touch.x, touch.y)){
            wLevel.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/waterlevel");
            changeMessage.addFloatArg(data.waterLevel);
            sender.sendMessage( changeMessage );
        }
    }
    
    if (data.activeLayer == 6){
        if (aSoil.isOver(touch.x, touch.y)){
            aSoil.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/absortionsoil");
            changeMessage.addFloatArg(data.absortionSoil);
            sender.sendMessage( changeMessage );
        } 
        
        if (dFlow.isOver(touch.x, touch.y)){
            dFlow.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/depresionflow");
            changeMessage.addFloatArg(data.depresionFlow);
            sender.sendMessage( changeMessage );
        } 
    }
    
    if ((data.activeLayer == 6) || (data.activeLayer == 9)){
        
        if (pAlt.isOver(touch.x, touch.y)){
            pAlt.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/precipitationaltitud");
            changeMessage.addFloatArg(data.precipitationAltitud);
            sender.sendMessage( changeMessage );
        } 
        
        if (pAmo.isOver(touch.x, touch.y)){
            pAmo.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/precipitationamount");
            changeMessage.addFloatArg(data.precipitationAmount);
            sender.sendMessage( changeMessage );
        } 
        
        if (pCold.isOver(touch.x, touch.y)){
            pCold.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/precipitationcold");
            changeMessage.addFloatArg(data.precipitationCold);
            sender.sendMessage( changeMessage );
        } 
        
        if (pHum.isOver(touch.x, touch.y)){
            pHum.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/precipitationhumidity");
            changeMessage.addFloatArg(data.precipitationHumidity);
            sender.sendMessage( changeMessage );
        } 
        
        if (pInc.isOver(touch.x, touch.y)){
            pInc.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/precipitationinclination");
            changeMessage.addFloatArg(data.precipitationInclination);
            sender.sendMessage( changeMessage );
        } 
    }
   
    if (data.activeLayer == 7){
        
        if (vDiffV.isOver(touch.x, touch.y)){
            vDiffV.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospherediffv");
            changeMessage.addFloatArg(data.biosphereDiffV);
            sender.sendMessage( changeMessage );
        } 
        
        if (vDiffU.isOver(touch.x, touch.y)){
            vDiffU.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospherediffu");
            changeMessage.addFloatArg(data.biosphereDiffU);
            sender.sendMessage( changeMessage );
        } 
        
        if (vF.isOver(touch.x, touch.y)){
            vF.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospheref");
            changeMessage.addFloatArg(data.biosphereF);
            sender.sendMessage( changeMessage );
        } 
        
        if (vK.isOver(touch.x, touch.y)){
            vK.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospherek");
            changeMessage.addFloatArg(data.biosphereK);
            sender.sendMessage( changeMessage );
        } 
    }
    
    if (data.activeLayer == 8){
        
        if (aMinDist.isOver(touch.x, touch.y)){
            aMinDist.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospheremindist");
            changeMessage.addFloatArg(data.biosphereMinDist);
            sender.sendMessage( changeMessage );
        } 
        
        if (aMaxDist.isOver(touch.x, touch.y)){
            aMaxDist.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospheremaxdist");
            changeMessage.addFloatArg(data.biosphereMaxDist);
            sender.sendMessage( changeMessage );
        } 
        
        if (aMaxForce.isOver(touch.x, touch.y)){
            aMaxForce.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospheremaxforce");
            changeMessage.addFloatArg(data.biosphereMaxForce);
            sender.sendMessage( changeMessage );
        } 
        
        if (aMaxSpeed.isOver(touch.x, touch.y)){
            aMaxSpeed.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospheremaxspeed");
            changeMessage.addFloatArg(data.biosphereMaxSpeed);
            sender.sendMessage( changeMessage );
        } 
        
        if (aSep.isOver(touch.x, touch.y)){
            aSep.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biosphereseparation");
            changeMessage.addFloatArg(data.biosphereSeparation);
            sender.sendMessage( changeMessage );
        } 
        
        if (aAli.isOver(touch.x, touch.y)){
            aAli.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospherealineation");
            changeMessage.addFloatArg(data.biosphereAlineation);
            sender.sendMessage( changeMessage );
        } 
        
        if (aCoh.isOver(touch.x, touch.y)){
            aCoh.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biospherecohesion");
            changeMessage.addFloatArg(data.biosphereCohesion);
            sender.sendMessage( changeMessage );
        } 
        
        if (aBor.isOver(touch.x, touch.y)){
            aBor.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/biosphereborders");
            changeMessage.addFloatArg(data.biosphereBorders);
            sender.sendMessage( changeMessage );
        } 
    }
    
    if (data.activeLayer == 9){
        
        if (aCirForce.isOver(touch.x, touch.y)){
            aCirForce.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/atmospherecircularforce");
            changeMessage.addFloatArg(data.atmosphereCircularForce);
            sender.sendMessage( changeMessage );
        } 
        
        if (aCirAngle.isOver(touch.x, touch.y)){
            aCirAngle.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/atmospherecircularangle");
            changeMessage.addFloatArg(data.atmosphereCircularAngle);
            sender.sendMessage( changeMessage );
        } 
        
        if (aTempDiss.isOver(touch.x, touch.y)){
            aTempDiss.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/atmosphereTempDiss");
            changeMessage.addFloatArg(data.atmosphereTempDiss);
            sender.sendMessage( changeMessage );
        }
        
        if (aVelDiss.isOver(touch.x, touch.y)){
            aVelDiss.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/atmosphereveldiss");
            changeMessage.addFloatArg(data.atmosphereVelDiss);
            sender.sendMessage( changeMessage );
        } 
        
        if (aDenDiss.isOver(touch.x, touch.y)){
            aDenDiss.pressAndMove(touch.x, touch.y);
            
            ofxOscMessage changeMessage;
            changeMessage.setAddress("/set/atmospheredendiss");
            changeMessage.addFloatArg(data.atmosphereDenDiss);
            sender.sendMessage( changeMessage );
        } 
    }
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
	if ( data.activeLayer == 0){
        mask.pointRelease();
    }
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

