//
//  ListingsTableViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/13/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "ListingsTableViewController.h"
#import "AFNetworking.h"
#import "BookListingViewController.h"

@interface ListingsTableViewController ()

//dummy data
@property (nonatomic, strong) NSArray *dummyBooks;
@property (nonatomic, strong) NSArray *dummyPrices;
@property (nonatomic, strong) NSArray *listings;

@property (nonatomic, strong) NSDictionary *selectedListing;

@end

@implementation ListingsTableViewController

#pragma mark - IBActions

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)testAPICall:(id)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://textbooky.csse.rose-hulman.edu:8000/users/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/JSON" forHTTPHeaderField:@"Content-type"];
    
    NSArray *objects = @[ @"test2", @"pass2", @"8121234567", @"Test", @"Name", @"NA", @"here", @5];
    NSArray *keys = @[ @"username", @"password", @"phonenum", @"firstname", @"lastname", @"photodir", @"location", @"transactioncount" ];
    
    NSDictionary *dataToPost = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataToPost options:0 error:&error];
    [request setHTTPBody:postData];
    
    //Deprecated in iOS 9, but still works...
    /*
    [[NSURLConnection alloc] 
     initWithRequest:request 
     delegate:self];
     */
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *urlResponse, NSData *responseData, NSError *requestError) {
                               // Check for Errors
                               if (requestError || !responseData) {
                                   // jump back to the main thread to update the UI
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"Something went wrong...");
                                   });
                               } else {
                                   // jump back to the main thread to update the UI
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"All going well...");
                                   });
                               }
                           }
     ];

    
    /*
    NSURLSession *session = [[NSURLSession alloc] init];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog([NSString stringWithFormat:@"%@", error]);
        } else {
            NSHTTPURLResponse *httpResponse = ((NSHTTPURLResponse *) response);
            NSLog([NSString stringWithFormat:@"%@", httpResponse]);
        }
    }] resume];
    */
}

#pragma mark - UITableViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //dummy data
    self.dummyBooks = @[ @"Fund. of Calculus, 12th Ed.", @"Greek Literature, 4th Ed.", @"EoPL, 3rd Ed." ];
    self.dummyPrices = @[ @"$78.00", @"$45.00", @"$52.00" ];
    
    //testing AFNetworking
    NSString *listingsUrl = @"http://textbooky.csse.rose-hulman.edu:8000/listings/";
    NSString *usersUrl = @"http://textbooky.csse.rose-hulman.edu:8000/users/";
    NSString *photosUrl = @"http://textbooky.csse.rose-hulman.edu:8000/listingphotos/";
    NSString *reviewsUrl = @"http://textbooky.csse.rose-hulman.edu:8000/reviews/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:listingsUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        self.listings = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedListing = self.listings[indexPath.row];
    [self performSegueWithIdentifier:@"selectedBookListingSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ListingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *currentListing = [self.listings objectAtIndex:indexPath.row];

    if ([[currentListing objectForKey:@"title"] class] == [NSNull class]) {
        cell.textLabel.text = @"TITLE IS NULL";
    }
    else {
        cell.textLabel.text = [currentListing objectForKey:@"title"];
    }
    
    if ([[currentListing objectForKey:@"price"] class] == [NSNull class]) {
        cell.detailTextLabel.text = @"PRICE IS NULL";
    }
    else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.02f", [[currentListing objectForKey:@"price"] doubleValue]];
    }
    
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"selectedBookListingSegue"]) {
        [((BookListingViewController *)[((UINavigationController *) [segue destinationViewController]) viewControllers][0]) setCurrentListing:self.selectedListing];
    }
}

@end
