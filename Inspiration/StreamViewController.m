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

@interface StreamViewController ()

@property (atomic, strong) NSMutableArray *streamItems;
@property (nonatomic, strong) UIPopoverController *imagePopUp;

- (void)refreshData;
- (IBAction)launchImagePicker:(id)sender;
- (void)mergeArray:(NSMutableArray *)original withArray:(NSArray *)target;

@end

@implementation StreamViewController

@synthesize streamItems, user = _user, imagePopUp;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.collectionView registerClass:[StreamCell class] forCellWithReuseIdentifier:@"STREAM_CELL"];
    self.streamItems = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(launchPicker:)
                                                 name:@"LaunchUIIMagePicker"
                                               object:nil];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = 30.0;
    flowLayout.minimumInteritemSpacing = 20.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(50, 50, 23.6, 0);
    
    [self refreshData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *identifier = [segue identifier];
    if ( [identifier isEqualToString:@"profile"] ) {
        ProfileViewController *profileController = segue.destinationViewController;
        profileController.delegate = self;
        profileController.user = self.user;
    } else if ([identifier isEqualToString:@"addContent"]) {
        ((UIStoryboardPopoverSegue *)segue).popoverController.delegate = self;
    }
}

- (void)refreshData {
    
    ///
    /// Load items from Cloudmine
    ///
    CMStore *store = [CMStore defaultStore];
    
    [store allObjectsWithOptions:nil callback:^(CMObjectFetchResponse *response) {
        DLog(@"Response: %@", response.objects);
        self.streamItems = [NSMutableArray arrayWithArray:response.objects];
        
        NSMutableArray *toRemove = [NSMutableArray array];
        
        for (id object in self.streamItems) {
            
            if ( ![object isKindOfClass:[StreamText class]] && ![object isKindOfClass:[StreamPicture class]] ) {
                [toRemove addObject:object];
            }
            
            if ([object isKindOfClass:[StreamPicture class]]) {
                StreamPicture *pic = (StreamPicture *)object;
                [store fileWithName:pic.imageName
                  additionalOptions:nil callback:^(CMFileFetchResponse *response) {
                      NSData *imageData = response.file.fileData;
                      if (imageData) {
                          pic.image = [UIImage imageWithData:imageData];
                          [self.collectionView reloadData];
                      }
                  }];
            }
            
        }
        
        for (id object in toRemove) {
            [self.streamItems removeObject:object];
        }
        
        DLog(@"Finished: %@", streamItems);
        
        [self.collectionView reloadData];
    }];
    
    /*
    
    
    
    [store allObjectsOfClass:[StreamText class] additionalOptions:nil callback:^(CMObjectFetchResponse *response) {
        
        [self mergeArray:self.streamItems withArray:response.objects];
        DLog(@"response: %@", response.objects);
        DLog(@"Text: %@", self.streamItems);
        [self.collectionView reloadData];
    }];
    
    
    [store allObjectsOfClass:[StreamPicture class] additionalOptions:nil callback:^(CMObjectFetchResponse *response) {
        [self mergeArray:self.streamItems withArray:response.objects];
        
        DLog(@"Pics: %@", self.streamItems);
        
        for (StreamPicture *picture in response.objects) {
            ///
            /// Get the actual Images
            ///
            [[CMStore store] fileWithName:picture.imageName
                        additionalOptions:nil
                                 callback:^(CMFileFetchResponse *response) {
                                     DLog(@"File: %@", response.file);
                                     ///
                                     /// Do Something
                                     ///
                                     
                                     NSData *imageData = response.file.fileData;
                                     if (imageData) {
                                         picture.image = [UIImage imageWithData:imageData];
                                     }
                                 }];
        }
        
        [self.collectionView reloadData];
    }];
     */
    
}

- (void)mergeArray:(NSMutableArray *)original withArray:(NSArray *)target {
    
    @synchronized(self) {
        DLog(@"Original: %@", original);
        DLog(@"Target: %@", target);
        
        NSMutableArray *toAddArray = [NSMutableArray array];
        
        if ([original count] == 0) {
            [original addObjectsFromArray:target];
            return;
        }
        
        for (id firstObject in original) {
            BOOL add = YES;
            for (id secondObject in target) {
                if ( [firstObject isEqual:secondObject] ) {
                    add = NO;
                }
            }
            if (add) {
                [toAddArray addObject:firstObject];
            }
        }
        
        for (id toAdd in toAddArray) {
            [original addObject:toAdd];
        }
        
        DLog(@"End: %@", original);
    }
    
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
    
    // Set this user as the user of the default store
    CMStore *store = [CMStore defaultStore];
    store.user = _user;
    
    // Save the user to preferences
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
    ///
    /// Refresh our stream
    ///
    [self refreshData];
}

- (IBAction)launchImagePicker:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePopUp = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [self.imagePopUp presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *imagePicked = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    ///
    /// Save the image
    ///
    NSData *imageData = UIImagePNGRepresentation(imagePicked);
    NSString *imageName = [NSString stringWithFormat:@"image%@%d", [[NSDate alloc] init], arc4random()];
    
    StreamPicture *picData = [[StreamPicture alloc] init];
    picData.imageName = imageName;
    
    [picData save:^(CMObjectUploadResponse *response) {
        DLog(@"Image Saved %@", response.uploadStatuses);
    }];
    
    [[CMStore store] saveFileWithData:imageData
                                named:imageName
                    additionalOptions:nil
                             callback:^(CMFileUploadResponse *response) {
                                 DLog(@"Image File Saved: %d", response.result);
                                 [self refreshData];
                             }];
    
    
    CMUser *user = [[CMStore store] user];
    
    if (user) {
        [picData saveWithUser:user callback:^(CMObjectUploadResponse *response) {
            DLog(@"Image Saved with User.");
        }];
        
        [[CMStore store] saveUserFileWithData:imageData
                                        named:imageName
                            additionalOptions:nil
                                     callback:^(CMFileUploadResponse *response) {
                                         DLog(@"Image Filed User Saved: %d", response.result);
                                         [self refreshData];
                                     }];
        
    }
        
    [self.imagePopUp dismissPopoverAnimated:YES];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewFlowLayout Deleage Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(350, 350);

}

@end
