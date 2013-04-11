//
//  HelperFunctions.m
//  LiarsDice
//
//  Created by David Raleigh on 4/11/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "HelperFunctions.h"

@implementation HelperFunctions

+ (UIView *)searchSubviewsForTaggedView:(int)tag inSubviews:(UIView *)view
{
    UIView *taggedView = nil;
    for (UIView *subview in view.subviews)
    {
        if (subview.tag == tag)
            return subview;
        else if ([subview.subviews count] > 0)
            taggedView = [self searchSubviewsForTaggedView:tag inSubviews:subview];
        
        if (taggedView != nil)
            return taggedView;
    }
    return taggedView;
}

@end
