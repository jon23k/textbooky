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
#import "ListingsMapViewController.h"

@interface ListingsTableViewController ()

@property (nonatomic, strong) NSArray *listings;

@property (nonatomic, strong) NSDictionary *selectedListing;

@property (nonatomic, strong) UIRefreshControl *refresher;

@end

@implementation ListingsTableViewController

#pragma mark - IBActions

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)pressedMap:(id)sender {
    [self performSegueWithIdentifier:@"MapSegue" sender:self];
}

- (IBAction)testAPICall:(id)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://textbooky.csse.rose-hulman.edu:8000/users/1/"]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/JSON" forHTTPHeaderField:@"Content-type"];
    
    NSArray *objects = @[ @"miskowbs", @"pass123", @"8129876543", @"Bart", @"Miskowiec", @"not applicable", @"not applicable", @0 ];
    NSArray *keys = @[ @"username", @"password", @"phonenum", @"firstname", @"lastname", @"photodir", @"location", @"transactioncount" ];
    
    NSDictionary *dataToPost = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataToPost options:0 error:&error];
    [request setHTTPBody:postData];
    
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
}

#pragma mark - UITableViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.refresher = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self refreshData];
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    NSDictionary *currentListing = [self.listings objectAtIndex:indexPath.row];
    
    if ([[currentListing objectForKey:@"userid"] isEqualToString:[NSString stringWithFormat:@"http://textbooky.csse.rose-hulman.edu:8000/users/%@/", [self.currentUser objectForKey:@"userid"]]]) {
        return YES;
    } else {
        return NO;
    }
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *currentListing = [self.listings objectAtIndex:indexPath.row];
        
        //delete row in DB
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[NSURL
                                                     URLWithString: [NSString stringWithFormat:@"http://textbooky.csse.rose-hulman.edu:8000/listings/%@/", [currentListing objectForKey:@"listingid"]]]];
        [request setHTTPMethod:@"DELETE"];
        [request setValue:@"application/JSON" forHTTPHeaderField:@"Content-type"];
        
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *urlResponse, NSData *responseData, NSError *requestError) {
                                   // Check for Errors
                                   if (requestError || !responseData) {
                                       // jump back to the main thread to update the UI
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           NSLog(@"Something went wrong...");
                                           [self refreshData];
                                       });
                                   } else {
                                       // jump back to the main thread to update the UI
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           NSLog(@"All going well...");
                                           [self refreshData];
                                       });
                                   }
                               }
         ];
        
        //delete row in table
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    
    if ([[segue identifier] isEqualToString:@"MapSegue"]) {
        [((ListingsMapViewController *)[((UINavigationController *) [segue destinationViewController]) viewControllers][0]) setListings:self.listings];
    }
}

#pragma mark - private

- (void)refreshTable {
    NSString *listingsUrl = @"http://textbooky.csse.rose-hulman.edu:8000/listings/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:listingsUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.listings = responseObject;
        
        [self.refresher endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)refreshData {
    NSString *listingsUrl = @"http://textbooky.csse.rose-hulman.edu:8000/listings/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:listingsUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.listings = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
