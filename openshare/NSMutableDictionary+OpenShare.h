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

- (void)appendDataToWeiXinTextShareWithMassage:(OSMessage *)message;
- (void)appendDataToWeiXinImageShareWithMassage:(OSMessage *)message;
- (void)appendDataToWeiXinLinkShareWithMassage:(OSMessage *)message;
- (void)appendDataToWeiXinMusicShareWithMassage:(OSMessage *)message;
- (void)appendDataToWeiXinVideoShareWithMassage:(OSMessage *)message;
- (void)appendDataToWeiXinAppShareWithMassage:(OSMessage *)message;
- (void)appendDataToWeiXinFileShareWithMassage:(OSMessage *)message;

@end
