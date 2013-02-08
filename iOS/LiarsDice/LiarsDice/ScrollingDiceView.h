//
//  ScrollingDiceView.h
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollingDiceView : UIImageView
{
    int numberOfRevolutions;
    int iterationTotal;
    
    int revolutionCount;
    int iterationCount;
    int finalFaceValue;
    
    CGFloat yIncrement;
    CGFloat yMinPosition;
    CGFloat yMaxPosition;
    CGFloat yLastPosition;
}

@property bool isFinished;


- (id)initWithFrame:(CGRect)frame andFaceValue:(int)faceValue;

- (void)scroll;
- (double)getCompleteDuration;
+ (int)maxIterationCount;
+ (double)maxDuration;
+ (double)animationHZ;
@end
