//
//  MLeaksMessenger.m
//  MLeaksFinder
//
//  Created by 佘泽坡 on 7/17/16.
//  Copyright © 2016 zeposhe. All rights reserved.
//

#import "MLeaksMessenger.h"
#import <UIKit/UIKit.h>

static __weak UIAlertView *alertView;

@implementation MLeaksMessenger

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
    UIAlertView *alertViewTemp = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [alertViewTemp show];
    alertView = alertViewTemp;
}

@end
