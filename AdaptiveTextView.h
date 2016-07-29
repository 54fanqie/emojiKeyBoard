//
//  AdaptiveTextView.h
//  Part of Chat
//
//  Created by macmini2 on 16/7/14.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdaptiveTextView;
@class EmojiInfo;
@protocol AdaptiveTextViewDelegate <NSObject>
- (void)textView:(AdaptiveTextView *)growingTextView shouldChangeHeight:(CGFloat)height;
- (void)textViewDidBeginEditing:(AdaptiveTextView *)growingTextView;

@end
@interface AdaptiveTextView : UITextView
- (void)insertEmoticon:(EmojiInfo *)emoticon;
@property (weak ,nonatomic) id<AdaptiveTextViewDelegate> delegete;
// 设置最大和最小行数
@property (nonatomic, assign) int maxNumberOfLines; 

@end
