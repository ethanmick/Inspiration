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

@property (nonatomic, strong) NSMutableArray *streamItems;

- (void)refreshData;

@end

@implementation StreamViewController

@synthesize streamItems, user = _user;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.collectionView registerClass:[StreamCell class] forCellWithReuseIdentifier:@"STREAM_CELL"];
    self.streamItems = [[NSMutableArray alloc] init];
    
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
        DLog(@"WTF IS THIS: %@", ((UIStoryboardPopoverSegue *)segue).popoverController );
        ((UIStoryboardPopoverSegue *)segue).popoverController.delegate = self;
    }
}

- (void)refreshData {
    
    ///
    /// Load items from Cloudmine
    ///
    CMStore *store = [CMStore defaultStore];
    
    
    [store allObjectsOfClass:[StreamText class] additionalOptions:nil callback:^(CMObjectFetchResponse *response) {
        
        NSMutableArray *toAdd = [NSMutableArray array];
        
        for (StreamText *returnedText in response.objects) {
            BOOL add = YES;
            for (StreamText *currentText in self.streamItems) {
                if ( [returnedText isEqual:currentText] ) {
                    add = NO;
                }
            }
            if (add) {
                [toAdd addObject:returnedText];
            }
        }
        
        for (StreamText *toAddText in toAdd) {
            [self.streamItems addObject:toAddText];
        }

        [self.collectionView reloadData];
    }];
    
    [store allObjectsOfClass:[StreamPicture class] additionalOptions:nil callback:^(CMObjectFetchResponse *response) {
        // Get the meta data about the pictures
        DLog(@"Pictures: %@", response.objects);
    }];
    
    
    
    [store fileWithName:@"BeautifulWoman.jpg" additionalOptions:nil callback:^(CMFileFetchResponse *response) {
        //NSData *imageData = response.file.fileData;
        //UIImage *image = [[UIImage alloc ] initWithData:imageData];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //imageView.frame = CGRectMake(100, 100, 400, 400);
        //[self.collectionView addSubview:imageView];
    }];
    
}

- (void)printing:(NSOrderedSet *)set {
    for (StreamText *text in set) {
        DLog(@"Text: %@ - %@", text.objectId, text.text);
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


#pragma mark - UICollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.streamItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StreamCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STREAM_CELL" forIndexPath:indexPath];
    
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
