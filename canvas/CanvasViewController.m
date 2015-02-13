//
//  CanvasViewController.m
//  canvas
//
//  Created by Bruce Ng on 2/12/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (weak, nonatomic) IBOutlet UIImageView *happyIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sadIcon;
@property (weak, nonatomic) IBOutlet UIImageView *excitedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *deadicon;
@property (weak, nonatomic) IBOutlet UIImageView *wikIcon;
@property (weak, nonatomic) IBOutlet UIImageView *tongueIcon;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (nonatomic,assign) CGPoint closedCenter;
@property (nonatomic,assign) CGPoint openCenter;
@property (nonatomic, strong) UIImageView *movingIcon;

@property (nonatomic,strong) UIPanGestureRecognizer *emojiPan;
@property (nonatomic, strong) UIPinchGestureRecognizer *emojiPinch;
@property (nonatomic, strong) UIRotationGestureRecognizer *emojiRotate;
@property (nonatomic, strong) UITapGestureRecognizer *emojiTap;

@property (nonatomic) BOOL isOpen;
@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isOpen = YES;
    
    self.openCenter = CGPointMake(self.trayView.center.x, self.trayView.center.y);
    self.closedCenter = CGPointMake(self.trayView.center.x, self.openCenter.y + 0.75 * self.trayView.frame.size.height);
    
    self.emojiPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanCanvasEmoji:)];
    self.emojiPan.delegate = self;
    self.emojiPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinchCanvasEmoji:)];
    self.emojiPinch.delegate = self;
    self.emojiRotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRotateCanvasEmoji:)];
    self.emojiRotate.delegate = self;
    self.emojiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCanvasEmoji:)];
    self.emojiTap.delegate = self;
    [self.emojiTap setNumberOfTapsRequired:2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction)onRotateCanvasEmoji:(UIRotationGestureRecognizer *)sender {
    
    sender.view.transform = CGAffineTransformRotate(sender.view.transform, sender.rotation);
}

- (IBAction)onTapCanvasEmoji:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}

- (IBAction)onPinchCanvasEmoji:(UIPinchGestureRecognizer *)sender {
    sender.view.transform = CGAffineTransformScale(sender.view.transform,
                                                   sender.scale,
                                                   sender.scale);
    sender.scale = 1.0;
}

- (IBAction)onPanCanvasEmoji:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    UIImageView *view = (UIImageView *)sender.view;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = CGAffineTransformScale(view.transform, 1.1, 1.1);
        }];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        view.center = location;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint imageCenter = sender.view.center;
        CGPoint trayViewTop = self.trayView.frame.origin;
        if (imageCenter.x > trayViewTop.x && imageCenter.y > trayViewTop.y ) {
            [sender.view removeFromSuperview];
        } else {
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = CGAffineTransformScale(view.transform, 1.0, 1.0);
        }];
        }
    }
}

- (IBAction)onPanEmoji:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView *newView = (UIImageView *)sender.view;
        self.movingIcon = [[UIImageView alloc] initWithImage:newView.image];
        self.movingIcon.center = newView.center;
        self.movingIcon.frame = newView.frame;
        [self.movingIcon setUserInteractionEnabled:YES];
        [self.movingIcon addGestureRecognizer:self.emojiPan];
        [self.movingIcon addGestureRecognizer:self.emojiPinch];
        [self.movingIcon addGestureRecognizer:self.emojiRotate];
        [self.movingIcon addGestureRecognizer:self.emojiTap];
        [self.view addSubview:self.movingIcon];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.movingIcon.center = location;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
    }

}


- (IBAction)onPanTray:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGFloat y = self.trayView.center.y + translation.y;
        if (y <= self.openCenter.y) {
            y = self.openCenter.y + translation.y / 10;
        } else if (y >= self.closedCenter.y) {
            y = self.closedCenter.y;
        }
        
        self.trayView.center = CGPointMake(self.trayView.center.x, y);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.y > 0) {
            // Closed State
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                // Close Shelf
                self.trayView.center = self.closedCenter;
            } completion:nil];
            
            if (self.isOpen) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
                }];
            }
        } else {
            // Open State
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                // Close Shelf
                self.trayView.center = self.openCenter;
            } completion:nil];
            if (!self.isOpen) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, M_PI);
                }];
            }

        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
