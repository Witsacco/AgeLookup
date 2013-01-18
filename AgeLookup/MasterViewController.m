//
//  MasterViewController.m
//  AgeLookup
//
//  Created by Ryan Witko on 1/10/13.
//  Copyright (c) 2013 Witsacco. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Person.h"
#import <AddressBook/AddressBook.h>

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize people = _people;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = @"Age Lookup";
    
    [self getAccesstoAddressBook];
}

- (void)getAccesstoAddressBook
{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            NSLog(@"We got in");
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        NSLog(@"Hacker");
        
        NSArray *thePeople = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
        // Do whatever you need with thePeople...
        NSLog(@"%d", sizeof(thePeople));

    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        NSLog(@"DENIED");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"PersonCell"];
    Person *person = [self.people objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [MasterViewController getFormattedAge:person.birthday];
    return cell;
}

+ (NSString *) getFormattedAge:(NSDate *)birthday
{
    // TODO: handle case when person does not have a birthday
    
    
    // Get the system calendar
    NSCalendar *cal =[NSCalendar currentCalendar];
    NSDate *now = [[NSDate alloc] init];
    
    // Request years, months, weeks
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit;
    
    NSDateComponents *comps = [cal components:unitFlags fromDate:birthday toDate:now options:0];

    int years = [comps year];
    int months = [comps month];

    NSLog(@"Age is %dyears %dmonths", years, months );

    // 10+ yrs: years
    if ( years >= 10 ) {
        return [ NSString stringWithFormat:@"%d years", years ];
    }
    // 2-10 yrs: year + half year
    else if ( years >= 2 ) {
        if ( months < 6 ) {
            return [ NSString stringWithFormat:@"%d years", years ];
        }
        else {
            return [ NSString stringWithFormat:@"%d½ years", years ];
        }
    }
    // 1-2 yrs: years + months
    else if ( years >= 1 ) {
        return [ NSString stringWithFormat:@"%d yr %d mo", years, months ];
    }
    // 6 mo - 1 yr : months
    else if ( months >= 6 ) {
        return [ NSString stringWithFormat:@"%d months", months ];
    }
    // 0-6 mos: weeks
    else {
        
        NSDateComponents * weekComp = [cal components:NSWeekCalendarUnit fromDate:birthday toDate:now options:0];

        return [ NSString stringWithFormat:@"%d weeks", [ weekComp week ] ];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
