//
//  ScrollingDiceView.m
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "ScrollingDiceView.h"

#define MAX_DURATION_SEC 6.0//1.5
#define MAX_FULL_REVOLUTIONS 12
#define ANIMATION_POSITIONS 12
#define MAX_ITERATION_COUNT (MAX_FULL_REVOLUTIONS * ANIMATION_POSITIONS - 1)
#define ANIMATION_DURATION (MAX_DURATION_SEC / MAX_ITERATION_COUNT)
#define ANIMATION_HZ (1.0 / ANIMATION_DURATION)
#define DICE_PER_IMAGE 8.0

@implementation ScrollingDiceView
{
    
}

@synthesize isFinished;

- (id)initWithFrame:(CGRect)frame andFaceValue:(int)faceValue
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self scrollSetup:frame andFaceValue:faceValue];
    }
    return self;
    
}

- (void)scrollSetup:(CGRect)frame andFaceValue:(int)faceValue
{
    numberOfRevolutions = (rand() % MAX_FULL_REVOLUTIONS) + 1;
    CGFloat spaceBetweenDice = frame.size.height / DICE_PER_IMAGE;
    yIncrement = spaceBetweenDice / 2.0;
    
    yMinPosition = frame.origin.y - spaceBetweenDice * 5.0 - yIncrement;
    yMaxPosition = frame.origin.y + yIncrement;
    yLastPosition = frame.origin.y - ((faceValue - 1) * spaceBetweenDice);
    
    iterationTotal = ANIMATION_POSITIONS * numberOfRevolutions + ((faceValue - 1) * 2);
    
    iterationCount = 0;
    revolutionCount = 0;
    finalFaceValue = faceValue;
    isFinished = false;
}

- (void)scroll
{
    if (iterationTotal == iterationCount)
    {
        isFinished = true;
        return;
    }
    
    CGRect workingFrame = self.frame;
    
    if (workingFrame.origin.y <= yMinPosition)
    {
        workingFrame.origin.y = yMaxPosition;
        [self setFrame:workingFrame];
        revolutionCount++;
    }
    
    workingFrame.origin.y -= yIncrement;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [self setFrame:workingFrame];
    [UIView commitAnimations];
    
    iterationCount++;
}

- (double)getCompleteDuration
{
    return iterationTotal * ANIMATION_DURATION;
}

+ (double)maxDuration
{
    return MAX_DURATION_SEC;
}

+ (int)maxIterationCount
{
    return (int)MAX_ITERATION_COUNT;
}

+ (double)animationHZ
{
    return ANIMATION_HZ;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
