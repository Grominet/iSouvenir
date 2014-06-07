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
#import <AddressBook/AddressBook.h>
#import "mesAnnotations.h"

@interface maView : UIView <MKMapViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
    //Interne
    BOOL isIpad;
    BOOL isIOS6;
    BOOL isBackground;
    BOOL isGeoCoding;
    BOOL isFollowingUserLocation;
    long compteur;
    
    // Manager
    CLLocationManager* monLocManager;

    // Vues
    MKMapView *maMapView;
    UIToolbar *maToolBar;
    
    // AlertView / ActionSheet
    UIActionSheet *geoCodingActionSheet;
    UIActionSheet *annotationListActionSheet;
    NSArray *maListeAnnotationsTriee;
    UIAlertView *addAnnotationAlertView;
    
    // ToolBar Button
    UIBarButtonItem *fixed10SpaceBarButton;
    UIBarButtonItem *flexibleSpaceBarButton;
    UIBarButtonItem *listAnnotationBarButton;
    UIBarButtonItem *addAnnotationBarButton;
    UIBarButtonItem *userLocationBarButton;
    UIBarButtonItem *switchGeoCoding;
    UIBarButtonItem *followUserLocationBarButton;
    
    // Gesture
    UILongPressGestureRecognizer *clickLong;
}

@property CLLocationCoordinate2D selectedCoordinate;

-(void)setFromOrientation:(UIInterfaceOrientation)orientation;

@end
