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
    [vue setVC:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [vue setFromOrientation:toInterfaceOrientation];
}


#pragma mark - AddressBook protocol

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // On obtient nos valeurs quand un contact est sélectionné
    NSString *firstName=(__bridge NSString *) (ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName=(__bridge NSString *) (ABRecordCopyValue(person, kABPersonLastNameProperty));
        
    // On cherche la dernière annotation selectionnée
    MKAnnotationView *annotationSelect=[vue lastAnnotationSelected];
    if (annotationSelect != nil) {
        mesAnnotations* annotationEnCours = [annotationSelect annotation];
        [annotationEnCours setSubtitle:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
    }
    
    // On referme
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];

    return NO; // NO = non on ne continue pas (pas d'ouverture de la fiche)
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
