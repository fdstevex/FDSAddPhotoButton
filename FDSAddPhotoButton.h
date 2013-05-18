//
//  FDSAddPhotoButton.h
//
//  Created by Steve Tibbett on 14/05/13.
//  Copyright (c) 2013 Fall Day Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDSAddPhotoButton;

@protocol FDSAddPhotoButtonDelegate <NSObject>
- (void)addPhotoButton:(FDSAddPhotoButton *)button didSelectPhoto:(UIImage *)image;
@end

@interface FDSAddPhotoButton : UIButton

@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet id<FDSAddPhotoButtonDelegate> addPhotoDelegate;
@property (weak, nonatomic) IBOutlet UIViewController *parentViewController;

@end
