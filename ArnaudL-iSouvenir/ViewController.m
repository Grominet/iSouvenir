//
//  ViewController.m
//  ArnaudL-iSouvenir
//
//  Created by Arnaud Leclaire on 03/06/2014.
//  Copyright (c) 2014 GromiNet. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController

#pragma mark - Initialize

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    vue = [[maView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[self view] addSubview:vue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [vue setFromOrientation:toInterfaceOrientation];
}

#pragma mark - ToolBar Image Management

/*+ (UIImage *)imageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:[image CGImage] scale:(image.scale * 50.0/24.0) orientation:image.imageOrientation];
}*/

@end
