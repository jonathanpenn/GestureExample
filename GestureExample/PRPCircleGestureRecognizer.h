/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
 ***/
//
//  PRPCircleGestureRecognizer.h
//  CircleGestureRecognizer
//
//  Created by Paul Warren on 10/03/10.
//  Copyright 2010 Primitive Dog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface PRPCircleGestureRecognizer : UIGestureRecognizer {
    
    CGPoint lowX;
    CGPoint highX;
    CGPoint lowY;
    CGPoint highY;
    BOOL moved;
}

@property (nonatomic, assign) CGFloat deviation;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, retain) NSMutableArray *points;

@end




