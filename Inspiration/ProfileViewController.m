//
//  ProfileViewController.m
//  Inspiration
//
//  Created by Ethan Mick on 10/15/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "ProfileViewController.h"
#import "SimpleKeychain.h"

@interface ProfileViewController () {
    __strong CMUserOperationCallback userCallback;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (void)login;
- (void)createAccountAndLogin;
- (IBAction)textFieldDidChange:(UITextField *)sender;

@end

@implementation ProfileViewController

@synthesize user = _user, delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Prevents retain cycle
    __block ProfileViewController *unretainedSelf = self;
    
    // Setup user operation callback
    userCallback = ^(CMUserAccountResult resultCode, NSArray *messages) {

        switch (resultCode) {
                // If the login succeded, notify the delegate
            case CMUserAccountLoginSucceeded:
                if ([unretainedSelf.delegate respondsToSelector:@selector(profileControllerDidSelectUser:)])
                    [unretainedSelf.delegate profileControllerDidSelectUser:unretainedSelf.user];
                break;
                
                // If the login failed, clear the password field and alert the user
            case CMUserAccountLoginFailedIncorrectCredentials: {
                unretainedSelf.passwordField.text = nil;
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:@"Your username or password was incorrect"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Okay"
                                                           otherButtonTitles:nil];
                [errorAlert show];
                break;
            }
                
            default:
                break;
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSDictionary *userInfo = [SimpleKeychain load:@"user"];
    
    self.usernameField.text = [userInfo valueForKey:@"username"];
    self.passwordField.text = [userInfo valueForKey:@"password"];
}

#pragma mark - Cloudmine Login Methods

- (void)login {
    if (!_user.userId.length || !_user.password.length)
        return;
    
    [_user loginWithCallback:userCallback];
}

- (void)createAccountAndLogin {
    if (!_user.userId.length || !_user.password.length)
        return;
    
    [_user createAccountAndLoginWithCallback:userCallback];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_usernameField])
        // Go to the password field if in the username field
        [_passwordField becomeFirstResponder];
    else if ([textField isEqual:_passwordField])
        // And attempt to login if in the password field
        [self login];
    
    return NO;
}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    // Update the user property as the text fields change
    if ([sender isEqual:_usernameField]) {
        _user.userId = _usernameField.text;
    } else if ([sender isEqual:_passwordField]) {
        _user.password = _passwordField.text;
    }
}




#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ///
    /// Regardless - save the info
    ///
    NSDictionary *userInfo = @{@"username" : self.usernameField.text, @"password" : self.passwordField.text};
    [SimpleKeychain save:@"user" data:userInfo];
    
    
    // If the user selects the login button
    // Simplier than making an outlet just to check
    if (indexPath.row == 0)
        [self login];
    
    // If the user selects the create account button
    // Simplier than making an outlet just to check
    if (indexPath.row == 1)
        [self createAccountAndLogin];
    
}



@end
