//
//  maView.m
//  ArnaudL-iSouvenir
//
//  Created by Arnaud Leclaire on 03/06/2014.
//  Copyright (c) 2014 GromiNet. All rights reserved.
//

#import "maView.h"
#import "mesAnnotations.h"

@implementation maView

# pragma mark - Initialize
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
            // Test iPad ou iPhone
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            isIpad = YES;
        } else {
            isIpad = NO;
        }
            // Test iOS6
        if ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0]=='6') {
            isIOS6 = YES;
        }
        else {
            isIOS6 = NO;
        }
            // Init paramètres localisation et mapView
        isGeoCoding = YES;
        isFollowingUserLocation = YES;
        
            // Init compteur
        compteur = 1;
        
        // Init Map View
        maMapView = [[MKMapView alloc] init];
        [maMapView setScrollEnabled:YES];
        [maMapView setZoomEnabled:YES];
        [maMapView setShowsUserLocation:isFollowingUserLocation];
        [maMapView setDelegate:self];
        [self addSubview:maMapView];

        // Init Gesture
            //Appui long
        clickLong =[[UILongPressGestureRecognizer alloc] init];
        [clickLong addTarget:self action:@selector(cliquageLong:)];
        [maMapView addGestureRecognizer:clickLong]; // on le lie à la MapView
        
        // Init ToolBar
            // Init bouton de la ToolBar
        //addAnnotationBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ios7-home-icon.png"] style:UIBarButtonItemStyleDone target:self action:@selector(refreshPage:)];
        followUserLocationBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(switchFollowUserLocation:)];
        addAnnotationBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addManualAnnotation:)];
        listAnnotationBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(getListAnnotation:)];
        switchGeoCoding = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(switchGeoCoding:)];
            // Standard space
        flexibleSpaceBarButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        fixed10SpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixed10SpaceBarButton setWidth:10];
            // Définir l'ordre
        NSArray* myTab = [NSArray arrayWithObjects:followUserLocationBarButton, fixed10SpaceBarButton, addAnnotationBarButton,flexibleSpaceBarButton,listAnnotationBarButton,flexibleSpaceBarButton,switchGeoCoding, nil];
            // et on addSubView
        maToolBar = [[UIToolbar alloc] init];
        [maToolBar setItems:myTab animated:YES];
        [maToolBar setAlpha:0.7];
        [self addSubview:maToolBar];
        
        // et on affiche tout ça
        [self setFromOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    }
    return self;
}

# pragma mark - View management
-(void)setFromOrientation:(UIInterfaceOrientation)orientation {
    
    // Gestion du frame
    // on récupère la frame de l'écran pour la redimensionner selon l'orientation
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if ( orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight )    {
        // mode Horizontal
        self.frame = CGRectMake(screenRect.origin.x,screenRect.origin.y,screenRect.size.height,screenRect.size.width);
    }else{
        // sinon mode Vertical (pas d'autres mode hein?)
        self.frame = CGRectMake(screenRect.origin.x,screenRect.origin.y,screenRect.size.width,screenRect.size.height);
    }
    
    // Getion des contraintes
        // Définition du dicitonnaire contenant les vues
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (maMapView, maToolBar);
    [maMapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [maToolBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
        // Gestion des contraintes des vues
    NSArray *maMapViewH = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|[maMapView]|" // H: optionnel
                           options:NSLayoutFormatAlignAllBaseline metrics:nil
                           views:viewsDictionary];
    NSArray *maMapViewV = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|[maMapView]|"
                           options:NSLayoutFormatAlignAllBaseline metrics:nil
                           views:viewsDictionary];
    NSArray *maToolBarH = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"H:|[maToolBar]|"
                           options:0 metrics:nil
                           views:viewsDictionary];
    NSArray *maToolBarV = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:[maToolBar]-|"
                           options:0 metrics:nil
                           views:viewsDictionary];
    
        // On ajoute les contraintes à la vue : c'est fini, trop facile!
    [self addConstraints:maMapViewH];
    [self addConstraints:maMapViewV];
    [self addConstraints:maToolBarH];
    [self addConstraints:maToolBarV];

    
}

# pragma mark - Actions Management

-(void)cliquageLong: (UILongPressGestureRecognizer *)gestureRecognizer {
    
    // Gestion d'un appui long
        // Place un marqueur
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) { // évenement à l'appui
        CGPoint touchPoint = [gestureRecognizer locationInView:maMapView]; // Où as-t-on cliqué?
        CLLocationCoordinate2D touchMapCoordinate =[maMapView convertPoint:touchPoint toCoordinateFromView:maMapView]; // et en coordonnées sur maMapView ça veut dire quoi?
        NSLog(@"clic long IN");

        [self addMyPlacemark:touchMapCoordinate]; // parfait! on envoi ça à la fonction
    }
}

-(void)addManualAnnotation:(id)sender{
    if (isGeoCoding) {
        addAnnotationAlertView = [[UIAlertView alloc] initWithTitle:@"Choisir un lieu" message:@"" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Chercher", nil];
        [addAnnotationAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [addAnnotationAlertView show];
    } else {
        [self addMyPlacemark:[maMapView centerCoordinate]]; // On place l'annotation direct
    }
}


-(void)getListAnnotation:(id)sender{
    NSArray *maListeAnnotations = [[NSArray alloc] initWithArray:[maMapView annotations]];
    annotationListActionSheet = [[UIActionSheet alloc] initWithTitle:@"Mes derniers lieux:"
                                                    delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
    
    //Tri par nom de lieu
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
     maListeAnnotationsTriee = [maListeAnnotations sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //BUG : limite l'affichage à i<9 car bug avec l'iPad si on doit scroller dans un ActionSheet
    
    if (maListeAnnotationsTriee.count>0) {
        for (int i=0; i<maListeAnnotationsTriee.count && i<9; i++) {
            [annotationListActionSheet addButtonWithTitle:[[maListeAnnotationsTriee objectAtIndex:i] title]];
            NSLog(@"%d : %@",i,[[maListeAnnotationsTriee objectAtIndex:i] title]);
        }
        [annotationListActionSheet addButtonWithTitle:@"Annuler"]; //ajout Cancel (tjs le dernier)
        if (isIpad) {
            //mode iPad
            [annotationListActionSheet showFromBarButtonItem:sender animated:YES];
        } else {
            //mode normal
            [annotationListActionSheet showFromToolbar:maToolBar];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Aucun lieu enregistré" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil] show];
    }

}

-(void)switchFollowUserLocation:(id)sender{
    isFollowingUserLocation = !isFollowingUserLocation;
    if (isFollowingUserLocation) {
        [followUserLocationBarButton setTintColor:nil];
    } else {
        [followUserLocationBarButton setTintColor:[UIColor grayColor]];
    }
}

-(void)switchGeoCoding:(id)sender{
    if (isGeoCoding) {
        geoCodingActionSheet = [[UIActionSheet alloc] initWithTitle:@"Désactiver le GeoCoding?" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Désactiver", nil];
    }else {
        geoCodingActionSheet = [[UIActionSheet alloc] initWithTitle:@"Activer le GeoCoding?" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Activer", nil];
    }
    
    if (isIpad) {
        //mode iPad
        [geoCodingActionSheet showFromBarButtonItem:sender animated:YES];
    } else {
        //mode normal
        [geoCodingActionSheet showFromToolbar:maToolBar];
    }

}


-(void)addMyPlacemark:(CLLocationCoordinate2D)location {
// Ajoute une annotation

    if (isGeoCoding) {
        //mode GeoCoding
        CLLocation* encLocation = [[CLLocation alloc] initWithCoordinate:location altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:encLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            //berk : un block
            if (error){
                NSLog(@"Geocode failed with error: %@", error);
                return;
            } else {
                // on attrape les addresses proches
                CLPlacemark *placemark = [placemarks firstObject];
                // on décode et log l'adresse
                NSLog(@"Geocode success: %@",[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]);

                //Note : besoin de #import <AddressBook/AddressBook.h> pour les kABPersonAddress...
                NSString *name = [placemark name];
                //NSString *street = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStreetKey];
                NSString *city = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCityKey];
                //NSString *state = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStateKey];
                //NSString *country = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCountryKey];
                //NSString *zip = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressZIPKey];
                
                NSString *myString = [[NSString alloc] init]; // au cas où un petit problème de syntaxe
                if (name == nil) {
                     myString = city;
                }else if (city == nil){
                     myString = name;
                }else{
                    myString = [NSString stringWithFormat:@"%@, %@",name,city];
                }
                
                // on crée l'annotation (à l'intérieur du block, sinon il faut faire un callback)
                mesAnnotations* nouvelleAnnotation = [[mesAnnotations alloc]init];
                [nouvelleAnnotation setTitle:myString];
                compteur++;
                [nouvelleAnnotation setCoordinate:[[placemark location] coordinate ]];
                [maMapView addAnnotation:nouvelleAnnotation];
                return;
            }
        }];
    } else {
        //mode absolu
        mesAnnotations* nouvelleAnnotation = [[mesAnnotations alloc]init];
        [nouvelleAnnotation setTitle:[NSString stringWithFormat:@"Lieu %ld",compteur++]];
        [nouvelleAnnotation setCoordinate:location];
        [maMapView addAnnotation:nouvelleAnnotation];
    }
}


# pragma mark - Annotation Protocol

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        //si pin de la classe de UserLocation : on ne change pas
        return nil;
    }

    if ([annotation isKindOfClass:[mesAnnotations class]])
    {
        //si pin de ma classe mesAnnotations : on personnalise
        MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation_ID"]; // réutilisation d'une annotation existante
        if (pin == nil) {
            //sinon on en créé une nouvelle
            pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"annotation_ID"];
        } else {
            [pin setAnnotation:annotation];
        }
        //personnalisation
        [pin setPinColor:MKPinAnnotationColorPurple];
        [pin setAnimatesDrop:YES];
        [pin setCanShowCallout:YES];
        [pin setDraggable:YES];
        [pin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
        return pin;
    }
    else {
        //si pin d'une autre classe : pas de personnalisation
        return nil;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // Vérification de la classe d'annotation cliquée
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[mesAnnotations class]])
    {
        // Actions sur l'annotation
        if ([(UIButton*)control buttonType] == UIButtonTypeContactAdd) {
            // Bouton ContactAdd
            
        }
        if ([(UIButton*)control buttonType] == UIButtonTypeInfoLight) {
            // Bouton InfoLight
            
        }
        
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (isFollowingUserLocation) {
        MKCoordinateRegion region;          //init
        MKCoordinateSpan span;              //init
        span.latitudeDelta = 0.035;
        span.longitudeDelta = 0.035;
        CLLocationCoordinate2D location;    //init
        location.latitude = userLocation.coordinate.latitude;
        location.longitude = userLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [mapView setRegion:region animated:YES];
    }
}


# pragma mark - ActionSheet Protocol

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"butIndex: %ld sur %ld",(long)buttonIndex, (long)[actionSheet numberOfButtons]);
    if (buttonIndex>=0)
        { // test si on a cliqué en dehors des boutons
            NSLog(@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]);
        if (![[actionSheet buttonTitleAtIndex:buttonIndex]  isEqual: @"Annuler"])
            { //Si on n'a pas annulé l'actionSheet avec un : !bouton = "Annuler"
            if (actionSheet == geoCodingActionSheet) {
                // Actions geoCodingActionSheet
                isGeoCoding = !isGeoCoding;
                if (isGeoCoding) {
                    [switchGeoCoding setTintColor:nil];
                } else {
                    [switchGeoCoding setTintColor:[UIColor grayColor]];
                }
            }
            
            if (actionSheet == annotationListActionSheet) {
                // Actions annotationListActionSheet
                if (buttonIndex<[actionSheet numberOfButtons] && buttonIndex>=0) {
                    //Index correct
                    NSLog(@"butInd: %ld et %@",(long)buttonIndex, [[maListeAnnotationsTriee objectAtIndex:buttonIndex] title]);
                    [maMapView selectAnnotation:[maListeAnnotationsTriee objectAtIndex:buttonIndex] animated:YES];
                }
            }
        } else {
            // Clic sur "Annuler"
        }
    } else  {
        // Clic en dehors de l'ActionSheet
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    //rien à faire, se ferme toute seule
}

#pragma mark - AlertView protocol

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == addAnnotationAlertView) {
        //Ajout manuel d'annotation via GeoCode
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:[[alertView textFieldAtIndex:0] text] completionHandler:^(NSArray *placemarks, NSError *error)
         {
            if (error){
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
             } else {
                 NSLog(@"Lieux trouvés: %@", placemarks);
                 CLPlacemark* placemark = [placemarks firstObject];
                 
                 //Note : besoin de #import <AddressBook/AddressBook.h> pour les kABPersonAddress...
                 NSString *name = [placemark name];
                 //NSString *street = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStreetKey];
                 NSString *city = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCityKey];
                 //NSString *state = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressStateKey];
                 //NSString *country = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressCountryKey];
                 //NSString *zip = [[placemark addressDictionary] objectForKey:(NSString *)kABPersonAddressZIPKey];
                 
                 NSString *myString = [[NSString alloc] init]; // au cas où un petit problème de syntaxe
                 if (name == nil) {
                     myString = city;
                 }else if (city == nil){
                     myString = name;
                 }else{
                     myString = [NSString stringWithFormat:@"%@, %@",name,city];
                 }
                 
                 // on crée l'annotation (à l'intérieur du block, sinon il faut faire un callback)
                 mesAnnotations* nouvelleAnnotation = [[mesAnnotations alloc] init];
                 [nouvelleAnnotation setTitle:myString];
                 compteur++; // ça peut servir pour autre chose...
                 [nouvelleAnnotation setCoordinate:[[placemark location] coordinate]];
                 [maMapView addAnnotation:nouvelleAnnotation];
                 [maMapView selectAnnotation:nouvelleAnnotation animated:YES];
                 return;
             }
         }];
    } else {
        //Gestion des AlertView temporaire
    }
}
-(void)alertViewCancel:(UIAlertView *)alertView
{
    //rien à faire, se ferme toute seule
}
@end