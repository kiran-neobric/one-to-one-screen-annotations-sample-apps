//
//  ShareViewController.m
//  ScreenShareSample
//
//  Created by Xi Huang on 5/19/16.
//  Copyright © 2016 Lucas Huang. All rights reserved.
//

#import "ScreenShareCaptureViewController.h"
#import "ScreenShareCaptureView.h"

@interface ScreenShareCaptureViewController ()
@property (nonatomic) CaptureModel *captureModel;
@property (strong, nonatomic) ScreenShareCaptureView *captureView;
@property (nonatomic) UIActivityViewController *activityViewController;
@end

@implementation ScreenShareCaptureViewController

- (void)setSharedImage:(UIImage *)sharedImage {
    _sharedImage = sharedImage;
    _captureModel = [[CaptureModel alloc] initWithSharedImage:sharedImage sharedDate:[NSDate date]];
    [self.captureView updateWithShareModel:_captureModel];
}

- (UIActivityViewController *)activityViewController {
    if (!_activityViewController) {
        _activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.captureModel.sharedImage] applicationActivities:nil];
    }
    return _activityViewController;
}

- (instancetype)initWithSharedImage:(UIImage *)sharedImage {
    
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"ScreenShareKitBundle" withExtension:@"bundle"]]]) {
    
        _captureModel = [[CaptureModel alloc] initWithSharedImage:sharedImage sharedDate:[NSDate date]];
        
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captureView = (ScreenShareCaptureView *)self.view;
    if (self.captureModel) {
        [self.captureView updateWithShareModel: self.captureModel];
    }
}

- (IBAction)shareButtonPressed:(id)sender {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:self.activityViewController animated:YES completion:nil];
    }
    else {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:self.activityViewController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4, 0, 0)
                               inView:self.captureView
             permittedArrowDirections:UIPopoverArrowDirectionAny
                             animated:YES];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.captureModel.sharedImage,
                                   self,
                                   @selector(finishSavingImage:error:contextInfo:),
                                   nil);
}

- (void)finishSavingImage:(UIImage *)savedImage
                    error:(NSError *)error
              contextInfo:(void *)contextInfo {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
