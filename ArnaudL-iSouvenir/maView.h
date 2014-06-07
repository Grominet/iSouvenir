//
//  maView.h
//  ArnaudL-iSouvenir
//
//  Created by Arnaud Leclaire on 03/06/2014.
//  Copyright (c) 2014 GromiNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "mesAnnotations.h"

@interface maView : UIView <CLLocationManagerDelegate, MKMapViewDelegate, UIActionSheetDelegate> {
    //Interne
    BOOL isIpad;
    BOOL isIOS6;
    BOOL isCalling;
    BOOL isBackground;
    BOOL isGeoCoding;
    long compteur;
    
    // Manager
    CLLocationManager* monLocManager;

    // Vues
    MKMapView *maMapView;
    UIToolbar *maToolBar;
    
    // AlertView / ActionSheet
    UIActionSheet *geoCodingActionSheet;
    
    // ToolBar Button
    UIBarButtonItem *fixed10SpaceBarButton;
    UIBarButtonItem *flexibleSpaceBarButton;
    UIBarButtonItem *listAnnotationBarButton;
    UIBarButtonItem *addAnnotationBarButton;
    UIBarButtonItem *userLocationBarButton;
    UIBarButtonItem *switchGeoCoding;
    
    // Gesture
    UILongPressGestureRecognizer *clickLong;
}

@property CLLocationCoordinate2D selectedCoordinate;

-(void)setFromOrientation:(UIInterfaceOrientation)orientation;

@end
