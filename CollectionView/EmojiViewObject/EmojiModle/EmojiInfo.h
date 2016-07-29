//
//  EmojiInfo.h
//  CollectionView
//
//  Created by macmini2 on 16/7/19.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface EmojiInfo : NSObject
@property (nonatomic,copy)   NSString * emojiName; //表情名称
@property (nonatomic,copy)   NSString * emojiImgName; //表情图片名称
@property (nonatomic,copy)   NSString * emojiString; //表情码文
@property (nonatomic,strong) UIImage  * emojiImage; //表情码文
@end
