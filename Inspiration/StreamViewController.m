//
//  ViewController.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamViewController.h"
#import "StreamCell.h"
#import "StreamText.h"
#import "StreamPicture.h"
#import "SelectedItemViewController.h"

@interface StreamViewController ()

@property (atomic, strong) NSMutableArray *streamItems;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIPopoverController *imagePopUp;
@property (nonatomic, strong) UIPopoverController *currentPopOver;
@property (nonatomic) BOOL globalStream;

- (void)refreshData;
- (IBAction)launchImagePicker:(id)sender;
- (void)dismissCurrentPopover;
- (void)refreshCollectionView;
- (void)parseResults:(NSArray *)array downloadCall:(SEL)selector forUser:(BOOL)user;

@end

@implementation StreamViewController

@synthesize streamItems, user = _user, imagePopUp, currentPopOver, selectedIndexPath;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.globalStream = YES;
    
	[self.collectionView registerClass:[StreamCell class] forCellWithReuseIdentifier:@"STREAM_CELL"];
    self.streamItems = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeStream:)
                                                 name:@"ChangeToPersonalStream"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCollectionView)
                                                 name:@"PictureFinishedDownloading"
                                               object:nil];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(280, 280);
    flowLayout.minimumLineSpacing = 30.0;
    flowLayout.minimumInteritemSpacing = 20.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(50, 50, 23.6, 0);
    
    [self refreshData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
        if (self.currentPopOver != nil) {
            [self.currentPopOver dismissPopoverAnimated:NO];
        }
        self.currentPopOver = ((UIStoryboardPopoverSegue *)segue).popoverController;
    }
    
    NSString *identifier = [segue identifier];
    if ( [identifier isEqualToString:@"profile"] ) { // Launching Profile UIPopoverController
        ProfileViewController *profileController = segue.destinationViewController;
        profileController.delegate = self;
        profileController.user = self.user;
        profileController.globalStream = self.globalStream;
    } else if ([identifier isEqualToString:@"addContent"]) { // "+" Button PopOver
        ((UIStoryboardPopoverSegue *)segue).popoverController.delegate = self;
    } else if ([identifier isEqualToString:@"selectedItem"]) { //User tapped an item
        SelectedItemViewController *selected = segue.destinationViewController;
        selected.content = [self.streamItems objectAtIndex:self.selectedIndexPath.row];
    }
}

- (void)changeStream:(NSNotification *)note {
    [self.streamItems removeAllObjects];
    self.globalStream = !self.globalStream;
    if (self.globalStream) {
        self.title = @"Global Stream";
    } else {
        self.title = @"My Stream";
    }
    [self refreshData];
}

- (void)refreshCollectionView {
    [self.collectionView reloadData];
}

///
/// Fix
///
- (void)refreshData {
    
    ///
    /// Load items from Cloudmine
    ///
    CMStore *store = [CMStore defaultStore];
    
    if (self.globalStream) {
        [store allObjectsWithOptions:nil callback:^(CMObjectFetchResponse *response) { //changed
            DLog(@"Response: %@", response.objects);
            [self parseResults:response.objects downloadCall:@selector(downloadContent) forUser:NO];
        }];
    } else {
        [store allUserObjectsWithOptions:nil callback:^(CMObjectFetchResponse *response) { //changed
            DLog(@"Response: %@", response.objects);
            [self parseResults:response.objects downloadCall:@selector(downloadContentForUser:) forUser:YES];
            }];
    }
}

- (void)parseResults:(NSArray *)array downloadCall:(SEL)selector forUser:(BOOL)user {
    self.streamItems = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *toRemove = [NSMutableArray array];
    
    for (id object in self.streamItems) {
        
        if ( ![object isKindOfClass:[StreamText class]] && ![object isKindOfClass:[StreamPicture class]] ) {
            [toRemove addObject:object];
        }
    }
    
    for (id object in toRemove) {
        [self.streamItems removeObject:object];
    }
    
    for (StreamItem *item in self.streamItems) {
        if (user) {
            [item performSelector:selector withObject:[[CMStore defaultStore] user]]; //lead
        } else {
            [item performSelector:selector]; //lead
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - Get/Set User

- (CMUser *)user {
    if (!_user) {
        // Attempt to load the user from preferences
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        if (userData)
            _user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        // If no user was found, create one
        if (!_user)
            _user = [[CMUser alloc] init];
        
        // Set this user as the user of the default store
        CMStore *store = [CMStore defaultStore];
        store.user = _user;
    }
    
    return _user;
}

- (void)setUser:(CMUser *)user {
    _user = user;

    CMStore *store = [CMStore defaultStore];
    store.user = _user;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_user] forKey:@"User"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - ProfileViewController Delegate

- (void)profileControllerDidSelectUser:(CMUser *)aUser {
    self.user = aUser;
    DLog(@"Created and Logged in!: %@ - %@", aUser.userId, aUser.password);
}

#pragma mark - UIPopOverController Delegate Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self refreshData];
}

- (IBAction)launchImagePicker:(id)sender {
    
    [self dismissCurrentPopover];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePopUp = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    self.currentPopOver = self.imagePopUp;
    [self.imagePopUp presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ///
    /// Generate a random name for the image.
    /// Paul Solt tells me that Marc told him this isn't necessary.
    /// Perhaps by using a CMFile object we can get around remembering the file
    /// Name.
    ///
    NSString *imageName = [NSString stringWithFormat:@"image-%@-%d-%@", [[NSDate alloc] init], arc4random(), [[NSUUID new] UUIDString]];
    
    StreamPicture *picData = [[StreamPicture alloc] init];
    picData.imageName = imageName;
    picData.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picData saveItem];
    
    CMUser *user = [[CMStore defaultStore] user];
    
    if ([user isLoggedIn]) {
        StreamPicture *picDataUser = [picData copy];
        [picDataUser saveItemWithUser:user];
    }
    
    [self.streamItems addObject:picData];
    [self.imagePopUp dismissPopoverAnimated:YES];
}


- (void)dismissCurrentPopover {
    
    if (self.currentPopOver != nil) {
        [self.currentPopOver dismissPopoverAnimated:NO];
    }
}

#pragma mark - UICollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.streamItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StreamCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STREAM_CELL" forIndexPath:indexPath];
    [cell reset];
    
    if ([[[self.streamItems objectAtIndex:indexPath.row] typeOfItem] isEqualToString:@"text"]) {
        [cell configureAsText:[self.streamItems objectAtIndex:indexPath.row]];
    } else if ([[[self.streamItems objectAtIndex:indexPath.row] typeOfItem] isEqualToString:@"picture"]) {
        [cell configureAsPicture:[self.streamItems objectAtIndex:indexPath.row]];
    }
    return cell;
}

/*
 ///
 /// Need to resize the cell content too.
 /// Can figure out later.
 ///
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGSize newCellSize = CGSizeZero;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
         newCellSize = CGSizeMake(280, 280);
    } else {
        newCellSize = CGSizeMake(350, 350);
    }
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize = newCellSize;
}
 */

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"selectedItem" sender:self];
}

@end
