//
//  EmojiScrollViewModel.m
//  EmojiScrollViewModel
//
//  Created by macmini2 on 16/7/20.
//  Copyright © 2016年 emiage. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//tabbar上的button
#define buttonWidth 45
#define buttonEdgeInsetTop    2.0
#define buttonEdgeInsetBottom 2.0
#define buttonEdgeInsetLeft   10.0
#define buttonEdgeInsetRight  10.0
#define lineHeight 3


#define EmojiButtonVerticalSpace 14 //上线间距(纵向)
#define EmojiButtonHeight 50.0 //大小
#define EmojiButtonWidth  45.0


@protocol SelectEmojiDelegate <NSObject>

-(void)selectEmoji:(NSInteger)index;

@end

@interface EmojiScrollViewModel : NSObject
@property (weak,nonatomic) id<SelectEmojiDelegate>emojiDelegate;
-(void)scrollViewLayoutWithEmojiArray:(NSArray*)images inView:(UIScrollView*)scrollView completionBlock:(void(^)(NSArray * emojiImages,NSInteger pageCount))block;
@end
