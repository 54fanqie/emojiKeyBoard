//
//  EmojiModel.m
//  CollectionView
//
//  Created by macmini2 on 16/7/19.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import "EmojiModel.h"
#import "EmojiInfo.h"
@implementation EmojiModel


+(NSMutableArray*)emojiInfoInWithBundleName:(NSString*)bundleName plistName:(NSString*)plistName{
    
    NSString *plistPath = [[self class] filePathWithBundleName:bundleName withFileName:plistName];
    NSArray * items = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray * emojiInfos = [NSMutableArray array];
    NSDictionary * dic =[NSDictionary dictionaryWithContentsOfFile:plistPath];
    items  = [NSArray arrayWithArray:dic[@"emoticons"]];
    //解析pilst文件
    for (NSDictionary * dic in items) {
        EmojiInfo * emoji = [[EmojiInfo alloc]init];
        emoji.emojiImgName= dic[@"png"];
        emoji.emojiString= dic[@"chs"];;//简体中文编码
        emoji.emojiImage =[UIImage imageWithContentsOfFile:[[self class] filePathWithBundleName:bundleName withFileName:dic[@"png"]]];
        [emojiInfos addObject:emoji];
    }
    return  emojiInfos;
}


+ (NSString *)filePathWithBundleName:(NSString *)bundleName withFileName:(NSString*)fileName {
    
    NSString * bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    
    return [NSString stringWithFormat:@"%@/%@",bundlePath,fileName];;
}

@end
