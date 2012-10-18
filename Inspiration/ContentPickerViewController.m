//
//  ContentPickerViewController.m
//  Inspiration
//
//  Created by Ethan Mick on 10/16/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "ContentPickerViewController.h"
#import "AddTextViewController.h"

@interface ContentPickerViewController ()

@end

@implementation ContentPickerViewController

@synthesize globalStream;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"textContent"]) {
        AddTextViewController *con = segue.destinationViewController;
        con.globalStream = self.globalStream;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

@end
