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
            //
        isGeoCoding = YES;
        
            // Init compteur
        compteur = 1;
        
        
        // Init Map View
        maMapView = [[MKMapView alloc] init];
        [maMapView setScrollEnabled:YES];
        [maMapView setZoomEnabled:YES];
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
        addAnnotationBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addManualAnnotation:)];
        userLocationBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(getUserLocation:)];
        listAnnotationBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(getListAnnotation:)];
        switchGeoCoding = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(switchGeoCoding:)];
            // Standard space
        flexibleSpaceBarButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        fixed10SpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [fixed10SpaceBarButton setWidth:10];
            // Définir l'ordre
        NSArray* myTab = [NSArray arrayWithObjects:addAnnotationBarButton,flexibleSpaceBarButton,userLocationBarButton,flexibleSpaceBarButton,listAnnotationBarButton,fixed10SpaceBarButton,switchGeoCoding, nil];
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
    
}

-(void)getUserLocation:(id)sender{
    
}

-(void)getListAnnotation:(id)sender{
    
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
    mesAnnotations* nouvelleAnnotation = [[mesAnnotations alloc]init];
    [nouvelleAnnotation setTitle:[NSString stringWithFormat:@"Lieu %ld",compteur++]];
    [nouvelleAnnotation setCoordinate:location];
    [maMapView addAnnotation:nouvelleAnnotation];

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

# pragma mark - LocationManager Protocol


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //_selectedCoordinate = [[locations lastObject] coordinate];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        } else {
            // on attrape les addresses proches
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            // on décode l'adresse
            NSString *adresse = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSLog(@"Vous avez choisi: %@",adresse);

            
            return;
        }
    }];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

# pragma mark - ActionSheet Protocol

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1) {
        //Si on n'a pas annulé l'actionSheet
        if (actionSheet == geoCodingActionSheet) {
            // Actions geoCodingActionSheet
            isGeoCoding = !isGeoCoding;
        }
        
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    //rien à faire, se ferme toute seule
}

@end