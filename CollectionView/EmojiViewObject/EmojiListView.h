//
//  EmojiListView.h
//  CollectionView
//
//  Created by macmini2 on 16/7/18.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmojiInfo;
@protocol SelectDelegate<NSObject>

-(void)insertEmoticon:(EmojiInfo*)emojiInfo;
@end

@interface EmojiListView : UIView
@property (weak,nonatomic) id<SelectDelegate>emojiDelegate;
@end
