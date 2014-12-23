//
//  CustomActivityIndicator.m
//  Weatherly
//
//  Created by Adam Cooper on 12/21/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "CustomActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "math.h"

static int stage = 0;

@interface CustomActivityIndicator ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CustomActivityIndicator
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"snowFlake"];
        imageView.tintColor = [UIColor whiteColor];
        [self addSubview:imageView];
        
        
    }
    return self;
    
}


-(void) startAnimating
{
    if (!self.timer.isValid) {
        self.timer =[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0];
        animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        animation.duration = 10.0;
        animation.repeatCount = HUGE_VALF;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.layer addAnimation:animation forKey:@"transform.rotation.z"];
    }
    
    self.hidden = NO;
    
    
    stage++;
}
-(void) stopAnimating
{
    self.hidden = YES;
    [self.timer invalidate];
}


@end
