//
//  MyGuiView.m
//  iPhone Empty Example
//
//  Created by theo on 26/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyGuiView.h"
#include "ofxiPhoneExtras.h"


@implementation MyGuiView

// called automatically after the view is loaded, can be treated like the constructor or setup() of this class

-(void)viewDidLoad {
	myApp = (testApp*)ofGetAppPtr();
}

-(IBAction) hostDoneEditing:(id)sender {
	UITextField * text = sender;
	myApp->serverHost = [text.text UTF8String];
    myApp->sender.setup(myApp->serverHost, myApp->serverPort);
} 

-(IBAction) connect:(id)sender {
    self.view.hidden = TRUE;
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
