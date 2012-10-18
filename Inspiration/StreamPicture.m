//
//  StreamPicture.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamPicture.h"

@interface StreamPicture () {
    __block CMStoreFileFetchCallback fileFetchResponse;
}


@end

@implementation StreamPicture

@synthesize imageName = _imageName;
@synthesize image;

- (id)init {
    if ( (self = [super init]) ) {
        self.typeOfItem = @"picture";
        [self setupBlock];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_imageName forKey:@"imageName"];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    if ((self = [super initWithCoder:aCoder])) {
        _imageName = [aCoder decodeObjectForKey:@"imageName"];
    }
    [self setupBlock];
    return self;
}

- (void)setupBlock {
    
    __block StreamPicture *unretainedSelf = self;
    
    fileFetchResponse = ^(CMFileFetchResponse *response) {
        NSData *imageData = response.file.fileData;
        if (imageData) {
            unretainedSelf.image = [UIImage imageWithData:imageData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PictureFinishedDownloading" object:unretainedSelf];
        }
    };
}

- (id)getContent {
    return self.image;
}

- (id)copyWithZone:(NSZone *)zone {
    StreamPicture *another = [[StreamPicture alloc] init];
    another.image = [self.image copy];
    another.imageName = [self.imageName copyWithZone:zone];
    return another;
}

- (void)saveItem {
    
    [self save:^(CMObjectUploadResponse *response) {
        DLog(@"Saved Item: %@ - %@", self.imageName, response.uploadStatuses);
    }];
    
    NSData *data = UIImagePNGRepresentation(self.image);
    [[CMStore defaultStore] saveFileWithData:data
                                       named:self.imageName
                           additionalOptions:nil
                                    callback:^(CMFileUploadResponse *response) {
                                        DLog(@"Saved Image File: %@ - %d", self.imageName, response.result);
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PictureFinishedDownloading" object:self];
                                    }];
}

- (void)saveItemWithUser:(CMUser *)user {
    [self saveWithUser:user callback:^(CMObjectUploadResponse *response) {
        DLog(@"Saved Item: %@ - %@", self.imageName, response.uploadStatuses);
    }];
    
    NSData *data = UIImagePNGRepresentation(self.image);
    
    [[CMStore defaultStore] saveUserFileWithData:data
                                           named:self.imageName
                               additionalOptions:nil
                                        callback:^(CMFileUploadResponse *response) {
                                            DLog(@"Saved Image File: %@ - %d", self.imageName, response.result);
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"PictureFinishedDownloading" object:self];
                                        }];
}

- (void)downloadContent {
    [[CMStore defaultStore] fileWithName:self.imageName
                       additionalOptions:nil
                                callback:fileFetchResponse];
}


- (void)downloadContentForUser:(CMUser *)user {
    
    [[CMStore defaultStore] userFileWithName:self.imageName
                           additionalOptions:nil
                                    callback:fileFetchResponse];
}

- (void)dealloc {
    self.image = nil;
}

@end
