//
//  NSMutableDictionary+OpenShare.m
//  openshare
//
//  Created by guoshencheng on 7/31/15.
//  Copyright (c) 2015 OpenShare http://openshare.gfzj.us/. All rights reserved.
//

#import "NSMutableDictionary+OpenShare.h"

@implementation NSMutableDictionary (OpenShare)

#pragma mark - WeiXin

- (void)appendDataToWeiXinTextShareWithMessage:(OSMessage *)message {
    self[@"command"] = @"1020";
    self[@"title"] = message.title;
}

- (void)appendDataToWeiXinImageShareWithMessage:(OSMessage *)message {
    self[@"fileData"] = message.image;
    self[@"thumbData"] = message.thumbnail ? : message.image;
    self[@"objectType"] = @"2";
}

- (void)appendDataToWeiXinLinkShareWithMessage:(OSMessage *)message {
    self[@"description"] = message.desc ? : message.title;
    self[@"mediaUrl"] = message.link;
    self[@"objectType"] = @"5";
    self[@"thumbData"] = message.thumbnail ? : message.image;
    self[@"title"] = message.title;
}

- (void)appendDataToWeiXinMusicShareWithMessage:(OSMessage *)message {
    self[@"description"] = message.desc ? : message.title;
    self[@"mediaUrl"] = message.link;
    self[@"mediaDataUrl"] = message.mediaDataUrl;
    self[@"objectType"] = @"3";
    self[@"thumbData"] = message.thumbnail ? : message.image;
    self[@"title"] = message.title;
}

- (void)appendDataToWeiXinVideoShareWithMessage:(OSMessage *)message {
    self[@"description"] = message.desc ? : message.title;
    self[@"mediaUrl"] = message.link;
    self[@"objectType"] = @"4";
    self[@"thumbData"] = message.thumbnail ? : message.image;
    self[@"title"] = message.title;
}

- (void)appendDataToWeiXinAppShareWithMessage:(OSMessage *)message {
    self[@"description"] = message.desc ? : message.title;
    if (message.extInfo) self[@"extInfo"] = message.extInfo;
    self[@"fileData"] = message.image;
    self[@"mediaUrl"] = message.link;
    self[@"objectType"] = @"7";
    self[@"thumbData"] = message.thumbnail ? : message.image;
    self[@"title"] = message.title;
}

- (void)appendDataToWeiXinFileShareWithMessage:(OSMessage *)message {
    self[@"description"] = message.desc ? : message.title;
    self[@"fileData"] = message.image;
    self[@"objectType"] = @"6";
    self[@"fileExt"] = message.fileExt ? : @"";
    self[@"thumbData"] = message.thumbnail ? : message.image;
    self[@"title"] = message.title;
}

#pragma mark - QQ

#pragma mark - WeiBo

@end
