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
#import <AddressBookUI/AddressBookUI.h>
#import "mesAnnotations.h"

@interface maView : UIView <MKMapViewDelegate, //Carte
                        UIActionSheetDelegate, //Popup ToolBar
                        UIAlertViewDelegate>   //Popup Alert
{
    //Interne
    BOOL isIpad;
    BOOL isIOS6;
    BOOL isBackground;
    BOOL isGeoCoding;
    BOOL isFollowingUserLocation;
    long compteur;
    
    // Manager
    CLLocationManager* monLocManager;
    ABPeoplePickerNavigationController *abNavController;

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

@property UIViewController *VC;
@property MKAnnotationView *lastAnnotationSelected; //retour AddressBook

-(void)setFromOrientation:(UIInterfaceOrientation)orientation;

@end
