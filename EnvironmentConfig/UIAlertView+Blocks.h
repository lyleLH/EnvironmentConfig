//
//  UIAlertView+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIButtonItem.h"

@interface UIAlertView (Blocks)

-(id)lh_initWithTitle:(NSString *)inTitle
           message:(NSString *)inMessage
  cancelButtonItem:(RIButtonItem *)inCancelButtonItem
  otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)lh_addButtonItem:(RIButtonItem *)item;

@end
