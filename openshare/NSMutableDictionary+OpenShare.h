//
//  NSMutableDictionary+OpenShare.h
//  openshare
//
//  Created by guoshencheng on 7/31/15.
//  Copyright (c) 2015 OpenShare http://openshare.gfzj.us/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenShare.h"

@interface NSMutableDictionary (OpenShare)

- (void)appendDataToWeiXinTextShareWithMessage:(OSMessage *)message;
- (void)appendDataToWeiXinImageShareWithMessage:(OSMessage *)message;
- (void)appendDataToWeiXinLinkShareWithMessage:(OSMessage *)message;
- (void)appendDataToWeiXinMusicShareWithMessage:(OSMessage *)message;
- (void)appendDataToWeiXinVideoShareWithMessage:(OSMessage *)message;
- (void)appendDataToWeiXinAppShareWithMessage:(OSMessage *)message;
- (void)appendDataToWeiXinFileShareWithMessage:(OSMessage *)message;

@end
