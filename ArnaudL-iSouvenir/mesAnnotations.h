//
//  mesAnnotations.h
//  ArnaudL-iSouvenir
//
//  Created by Arnaud Leclaire on 06/06/2014.
//  Copyright (c) 2014 GromiNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface mesAnnotations : NSObject <MKAnnotation>

// besoin?
@property (nonatomic,assign,readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy,readwrite) NSString *title;
@property (nonatomic,copy,readwrite) NSString *subtitle;


@end
