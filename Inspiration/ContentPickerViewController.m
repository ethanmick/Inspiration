//
//  ContentPickerViewController.m
//  Inspiration
//
//  Created by Ethan Mick on 10/16/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "ContentPickerViewController.h"

@interface ContentPickerViewController ()

@end

@implementation ContentPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ///
    /// Change The navigation back button to make sure the user understands
    /// we are saving the info.
    ///
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ///
    /// Get an Image
    ///
    if (indexPath.row == 1) {
        
    }
}

@end
