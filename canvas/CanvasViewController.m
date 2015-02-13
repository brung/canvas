//
//  CanvasViewController.m
//  canvas
//
//  Created by Bruce Ng on 2/12/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (weak, nonatomic) IBOutlet UIImageView *happyIcon;
@property (weak, nonatomic) IBOutlet UIImageView *sadIcon;
@property (weak, nonatomic) IBOutlet UIImageView *excitedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *deadicon;
@property (weak, nonatomic) IBOutlet UIImageView *wikIcon;
@property (weak, nonatomic) IBOutlet UIImageView *tongueIcon;

@property (nonatomic,assign) CGPoint closedCenter;
@property (nonatomic,assign) CGPoint openCenter;
@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.openCenter = CGPointMake(self.trayView.center.x, self.trayView.center.y);
    self.closedCenter = CGPointMake(self.trayView.center.x, self.openCenter.y + 0.75 * self.trayView.frame.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPanTray:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGFloat y = self.trayView.center.y + translation.y;
        if (y <= self.openCenter.y) {
            y = self.openCenter.y;
        } else if (y >= self.closedCenter.y) {
            y = self.closedCenter.y;
        }
        
        self.trayView.center = CGPointMake(self.trayView.center.x, y);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.y > 0) {
            // Closed State
            [UIView animateWithDuration:0.3 animations:^{
               // Close Shelf
                self.trayView.center = self.closedCenter;
            }];
        } else {
            // Open State
            [UIView animateWithDuration:0.3 animations:^{
                // Close Shelf
                self.trayView.center = self.openCenter;
            }];
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
