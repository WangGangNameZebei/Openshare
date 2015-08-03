//
//  OpenShare+Weixin.m
//  openshare
//
//  Created by LiuLogan on 15/5/18.
//  Copyright (c) 2015年 OpenShare <http://openshare.gfzj.us/>. All rights reserved.
//

#import "OpenShare+Weixin.h"
#import "NSMutableDictionary+OpenShare.h"

@implementation OpenShare (Weixin)
static NSString *schema=@"Weixin";
+ (void)connectWeixinWithAppId:(NSString *)appId {
    [self set:schema Keys:@{@"appid":appId}];

}
+ (BOOL)isWeixinInstalled {
    return [self canOpen:@"weixin://"];
}

+ (void)shareToWeixinSession:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail {
    if ([self beginShare:schema Message:msg Success:success Fail:fail]) {
        [self openURL:[self genWeixinShareUrl:msg to:0]];
    }
}

+ (void)shareToWeixinTimeline:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail {
    if ([self beginShare:schema Message:msg Success:success Fail:fail]) {
        [self openURL:[self genWeixinShareUrl:msg to:1]];
    }
}

+(void)shareToWeixinFavorite:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail {
    if ([self beginShare:schema Message:msg Success:success Fail:fail]) {
        [self openURL:[self genWeixinShareUrl:msg to:2]];
    }
}

/**
 *  把msg分享到shareTO
 *
 *  @param msg     OSmessage
 *  @param shareTo 0是好友／1是QQ空间。
 *
 *  @return 需要打开的url
 */
+ (NSString *)genWeixinShareUrl:(OSMessage*)msg to:(int)shareTo {
    NSMutableDictionary *dic = [OpenShare DefaultShareDictionaryWithShareTo:shareTo];
    if (msg.multimediaType==OSMultimediaTypeNews) {
        msg.multimediaType=0;
    }
    if (!msg.multimediaType) {
        //不指定类型
        if ([msg isEmpty:@[@"image",@"link"] AndNotEmpty:@[@"title"]]) {
            [dic appendDataToWeiXinTextShareWithMessage:msg];
        } else if([msg isEmpty:@[@"link"] AndNotEmpty:@[@"image"]]) {
            [dic appendDataToWeiXinImageShareWithMessage:msg];
        } else if([msg isEmpty:nil AndNotEmpty:@[@"link",@"title",@"image"]]) {
            [dic appendDataToWeiXinLinkShareWithMessage:msg];
        }
    } else if(msg.multimediaType==OSMultimediaTypeAudio) {
        [dic appendDataToWeiXinMusicShareWithMessage:msg];
    } else if(msg.multimediaType==OSMultimediaTypeVideo) {
        [dic appendDataToWeiXinVideoShareWithMessage:msg];
    } else if(msg.multimediaType==OSMultimediaTypeApp) {
        [dic appendDataToWeiXinAppShareWithMessage:msg];
    } else if(msg.multimediaType==OSMultimediaTypeFile) {
        [dic appendDataToWeiXinFileShareWithMessage:msg];
    }
    NSData *output=[NSPropertyListSerialization dataWithPropertyList:@{[self keyFor:schema][@"appid"]:dic} format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
    [[UIPasteboard generalPasteboard] setData:output forPasteboardType:@"content"];
    return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",[self keyFor:schema][@"appid"]];
}

/**
 *  注意：微信登录权限仅限已获得认证的开发者申请，请先进行开发者认证
 *
 *  @param scope   scope
 *  @param success 登录成功回调
 *  @param fail    登录失败回调
 */
+ (void)WeixinAuth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail {
    if ([self beginAuth:schema Success:success Fail:fail]) {
        [self openURL:[NSString stringWithFormat:@"weixin://app/%@/auth/?scope=%@&state=Weixinauth",[self keyFor:schema][@"appid"],scope]];
    }
}

+ (BOOL)Weixin_handleOpenURL {
    NSURL *url = [self returnedURL];
    if ([url.scheme hasPrefix:@"wx"]) {
        NSDictionary *retDic = [NSPropertyListSerialization propertyListWithData:[[UIPasteboard generalPasteboard] dataForPasteboardType:@"content"]? : [[NSData alloc] init] options:0 format:0 error:nil][[self keyFor:schema][@"appid"]];
        NSLog(@"retDic\n%@",retDic);
        if ([url.absoluteString rangeOfString:@"://oauth"].location != NSNotFound) {
            if ([self authSuccessCallback]) {
                [self authSuccessCallback]([self parseUrl:url]);
            }
        } else {
            if (retDic[@"state"]&&[retDic[@"state"] isEqualToString:@"Weixinauth"]&&[retDic[@"result"] intValue]!=0) {
                if ([self authFailCallback]) {
                    [self authFailCallback](retDic,[NSError errorWithDomain:@"weixin_auth" code:[retDic[@"result"] intValue] userInfo:retDic]);
                }
            } else if([retDic[@"result"] intValue]==0){
                if ([self shareSuccessCallback]) {
                    [self shareSuccessCallback]([self message]);
                }
            } else {
                if ([self shareFailCallback]) {
                    [self shareFailCallback]([self message],[NSError errorWithDomain:@"weixin_share" code:[retDic[@"result"] intValue] userInfo:retDic]);
                }
            }
        }
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - PrivateMethod

+ (NSMutableDictionary *)DefaultShareDictionaryWithShareTo:(int)ShareTo {
    return [[NSMutableDictionary alloc] initWithDictionary:@{@"result":@"1",@"returnFromApp" :@"0",@"scene" : [NSString stringWithFormat:@"%d",ShareTo],@"sdkver" : @"1.5",@"command" : @"1010"}];
}

@end
