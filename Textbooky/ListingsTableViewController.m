//
//  ListingsTableViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/13/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "ListingsTableViewController.h"
#import "AFNetworking.h"

@interface ListingsTableViewController ()

//dummy data
@property (nonatomic, strong) NSArray *dummyBooks;
@property (nonatomic, strong) NSArray *dummyPrices;

@end

@implementation ListingsTableViewController

#pragma mark - IBActions

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)testAPICall:(id)sender {
    //testing AFNetworking
    NSString *url = @"http://jsonplaceholder.typicode.com/posts/1";
    
    /*
    NSString *listingsUrl = @"http://137.112.228.243:8000/listings";
    NSString *usersUrl = @"http://137.112.228.243:8000/users";
    NSString *photosUrl = @"http://137.112.228.243:8000/listingphotos";
    NSString *reviewsUrl = @"http://137.112.228.243:8000/reviews";
    */

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSLog(@"id value: %@", [responseObject objectForKey:@"id"]);
        NSArray *keys = [responseObject allKeys];
        NSLog(@"key 0: %@", keys[0]);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - UITableViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //dummy data
    self.dummyBooks = @[ @"Fund. of Calculus, 12th Ed.", @"Greek Literature, 4th Ed.", @"EoPL, 3rd Ed." ];
    self.dummyPrices = @[ @"$78.00", @"$45.00", @"$52.00" ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"selectedBookListingSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dummyBooks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ListingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.dummyBooks objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.dummyPrices objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
