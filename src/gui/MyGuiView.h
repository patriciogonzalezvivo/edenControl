//
//  MyGuiView.h
//  iPhone Empty Example
//
//  Created by theo on 26/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "testApp.h"

@interface MyGuiView : UIViewController {
	IBOutlet UILabel *displayText;
	
	testApp *myApp;		// points to our instance of testApp
}

-(IBAction) hostDoneEditing:(id)sender;
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(IBAction) connect:(id)sender;

@end
