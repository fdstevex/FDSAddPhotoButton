//
//  FDSAddPhotoButton.m
//
//  Created by Steve Tibbett on 14/05/13.
//  Copyright (c) 2013 Fall Day Software Inc. All rights reserved.
//

#import "FDSAddPhotoButton.h"
#import <QuartzCore/QuartzCore.h>

@interface FDSAddPhotoButton () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) CAShapeLayer *borderLayer;
@property (strong, nonatomic) UIView *frameView;
@property (strong, nonatomic) UIImageView *photoView;
@property (strong, nonatomic) UILabel *editLabel;
@property (strong, nonatomic) UIPopoverController *currentPopover;
@property (strong, nonatomic) UIActionSheet *currentActionSheet;
@end

@implementation FDSAddPhotoButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self finishInitialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self finishInitialization];
    }
    return self;
}

- (void)finishInitialization
{
    self.adjustsImageWhenHighlighted = NO;
    
    [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateHighlighted];

    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //Border
    self.borderLayer = [CAShapeLayer layer];
    self.borderLayer.fillColor = [[UIColor clearColor] CGColor];
    self.borderLayer.strokeColor = [[UIColor grayColor] CGColor];
    self.borderLayer.lineWidth = 1.;
    self.borderLayer.lineDashPattern = @[ @4, @2];
    [self.layer addSublayer:self.borderLayer];

    // The white photo frame
    self.frameView = [[UIView alloc] init];
    self.frameView.hidden = YES;
    self.frameView.layer.borderColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.25 alpha:0.25].CGColor;
    self.frameView.layer.borderWidth = 0.5;
    self.frameView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.frameView.layer.shadowOffset = CGSizeMake(0, 1.0);
    self.frameView.layer.shadowOpacity = 0.75;
    self.frameView.layer.shadowRadius = 1.0;
    self.frameView.backgroundColor = [UIColor whiteColor];
    self.frameView.opaque = YES;
    self.frameView.userInteractionEnabled = NO;
    [self addSubview:self.frameView];
    
    // The photo itself
    self.photoView = [[UIImageView alloc] init];
    self.photoView.hidden = YES;
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.clipsToBounds = YES;
    [self addSubview:self.photoView];
    
    // The "edit" label on the photo
    self.editLabel = [[UILabel alloc] init];
    self.editLabel.hidden = YES;
    self.editLabel.text = @"edit";
    self.editLabel.textColor = [UIColor whiteColor];
    self.editLabel.font = [UIFont systemFontOfSize:13];
    self.editLabel.textAlignment = NSTextAlignmentCenter;
    self.editLabel.opaque = NO;
    self.editLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.editLabel sizeToFit];
    [self addSubview:self.editLabel];
    
    [self addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

// From http://www.cocoanetics.com/2010/02/drawing-rounded-rectangles/

- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.photo == nil) {
        // No photo; show as "add photo"
        self.editLabel.hidden = YES;
        self.frameView.hidden = YES;
        self.photoView.hidden = YES;
        self.borderLayer.hidden = NO;
        self.titleLabel.hidden = NO;
        
        self.borderLayer.path = [self newPathForRoundedRect:self.bounds radius:8.0];
        self.borderLayer.frame = self.bounds;
    } else {
        // Photo selected; show the photo
        
        self.borderLayer.hidden = YES;
        self.editLabel.hidden = NO;
        self.frameView.hidden = NO;
        self.photoView.hidden = NO;
        self.titleLabel.hidden = YES;
        
        self.frameView.frame = self.bounds;
        
        self.photoView.frame = CGRectInset(self.bounds, 5, 5);
        self.editLabel.frame = CGRectMake(self.photoView.frame.origin.x,
                                          self.photoView.frame.origin.y + self.photoView.frame.size.height - self.editLabel.frame.size.height,
                                          self.photoView.frame.size.width,
                                          self.editLabel.frame.size.height);
    }
}

- (void)setPhoto:(UIImage *)photo
{
    _photo = photo;
    
    self.photoView.image = photo;
    
    [self setNeedsLayout];
}

- (void)buttonTapped:(id)sender
{
    [self pickPhoto];
}

- (void) pickPhoto
{
    if (self.currentPopover != nil) {
        [self.currentPopover dismissPopoverAnimated:YES];
        self.currentPopover = nil;
        return;
    }
    
    if (self.photo != nil) {
        self.currentActionSheet = [[UIActionSheet alloc] initWithTitle:@"Selected Photo"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Remove Photo", nil];
        [self.currentActionSheet showFromRect:self.bounds inView:self animated:YES];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.currentPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
            self.currentPopover.delegate = self;
            [self.currentPopover presentPopoverFromRect:self.bounds
                                                 inView:self
                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                               animated:YES];
        } else {
            [self.parentViewController presentViewController:picker animated:YES completion:nil];
        }
        
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == self.currentPopover) {
        self.currentPopover = nil;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Dismiss the picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Get the image from the result
    UIImage* image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    self.photo = image;

    // Notify the delegate
    if (self.addPhotoDelegate) {
        [self.addPhotoDelegate addPhotoButton:self didSelectPhoto:self.photo];
    }
    
    if (self.currentPopover) {
        [self.currentPopover dismissPopoverAnimated:YES];
        self.currentPopover = nil;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        self.photo = nil;

        // Notify the delegate that the photo was removed
        if (self.addPhotoDelegate) {
            [self.addPhotoDelegate addPhotoButton:self didSelectPhoto:nil];
        }
    }
    
    self.currentActionSheet = nil;
}

@end
