//
//  EmojiScrollViewModel.m
//  EmojiScrollViewModel
//
//  Created by macmini2 on 16/7/20.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import "EmojiScrollViewModel.h"
#import "EmojiInfo.h"
@interface EmojiScrollViewModel()
{
    CGFloat     width  ;
    CGFloat    height  ;
    NSInteger     row  ;
    NSInteger   count  ;
    NSInteger section  ;
    CGFloat   emojiButtonHorizontalSpace; //横向间距(水平)
    NSMutableArray * allEmoji;
}

@end
@implementation EmojiScrollViewModel

-(void)scrollViewLayoutWithEmojiArray:(NSArray*)images inView:(UIScrollView*)scrollView  completionBlock:(void(^)( NSArray * emojiImages, NSInteger pageCount))block{
    
    width  = CGRectGetWidth(scrollView.frame);
    height  = CGRectGetHeight(scrollView.frame);
    row  = width/EmojiButtonWidth;
    count  = images.count;
    section  = [self scrollerViewSection];
    emojiButtonHorizontalSpace = (float)(width -row*EmojiButtonWidth)/(row+1);
    
    //数据处理
    allEmoji = [self addDeleteButtonEmojiInfos:images];
    //根据分区不同拆分数组
    NSMutableArray * emojiViews = [NSMutableArray array];
    for (NSInteger a=0; a<section; a++) {
        NSMutableArray * sectionContent = [NSMutableArray array];
        for (NSInteger b=0; b<3*row; b++) {
            NSInteger c = a*row*3 + b;
            [sectionContent addObject:allEmoji[c]];
        }
        [emojiViews addObject:sectionContent];
    }
    
    
    
    //创建视图
    for (NSInteger i=0; i<emojiViews.count; i++) {
        NSArray * viewMu = emojiViews[i];
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(width*i, 0, width,height)];
        [self viewAddSubViewsEmojis:viewMu inView:view withPageViewNum:i];
        [scrollView addSubview:view];
    }
    scrollView.contentSize = CGSizeMake(width*emojiViews.count, 0);
    
    if(block){
        block(allEmoji,section);
    };
}
#pragma mark 添加表情
-(void)viewAddSubViewsEmojis:(NSArray*)emojis  inView:(UIView*)view withPageViewNum:(NSUInteger)page{
    for (NSInteger j=0; j<emojis.count; j++) {
        EmojiInfo * emojiInfo = emojis[j];
        UIButton * emojiBtn = [[UIButton alloc]initWithFrame:CGRectMake((j%row)*EmojiButtonWidth+((j%row)+1)*emojiButtonHorizontalSpace, 10+(j/row)*EmojiButtonHeight + (j/row)*EmojiButtonVerticalSpace, EmojiButtonWidth, EmojiButtonHeight)];
        [emojiBtn addTarget:self action:@selector(selectEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [emojiBtn setImage:emojiInfo.emojiImage forState:UIControlStateNormal];
        [emojiBtn setAdjustsImageWhenHighlighted:NO];
        emojiBtn.tag=page*row*3+j;
        [view addSubview:emojiBtn];
    }
}









#pragma mark 数据处理

#pragma mark 如果获取的表情数刚好是row的整数倍这section要+1 因为还有加删除图标
-(NSInteger)scrollerViewSection{
    NSInteger num  = count/(row*3)+1;
    if ( num+count> num*row*3) {
        num+=1;
    }
    return num;
}
#pragma mark 把删除按钮加进去,然后在添加空数据占位 这样最后一个删除按钮才能在末尾
-(NSMutableArray*)addDeleteButtonEmojiInfos:(NSArray*)emojis{
    EmojiInfo  * emojiInfo = [[EmojiInfo alloc]init];
    emojiInfo.emojiImage = [UIImage imageNamed:@"compose_emotion_delete"];
    emojiInfo.emojiString =@"[删除]";
    NSMutableArray * emojiInfos= [NSMutableArray arrayWithArray:emojis];
    
    for (NSInteger i=0; i<section-1; i++) {//先在吧前section - 1的删除按钮加进去
        NSInteger index = (row*3-1)*(i+1)+i;
        [emojiInfos insertObject:emojiInfo atIndex:index];
    }
    
    NSInteger num = section*row*3 - emojiInfos.count;
    NSInteger insertNum = emojiInfos.count;
    if (num>0) {
        for (NSInteger j=0; j<num-1; j++) {
            EmojiInfo  * emojiInfo = [[EmojiInfo alloc]init];
            emojiInfo.emojiString =@"[添加的空数据]";
            [emojiInfos insertObject:emojiInfo atIndex:j+insertNum];
        }
        [emojiInfos insertObject:emojiInfo atIndex:num+insertNum-1];
    }
    return emojiInfos;
}

#pragma mark 判断当前数组是否是当前section的整数倍
-(BOOL)judgeInteger:(NSInteger)num1 with:(NSInteger)num2
{
    NSNumber * num3 = [NSNumber numberWithInteger:num2];
    double s1=[num3 doubleValue];
    int s2=[num3 intValue];
    if (s1/num1-s2/num1>0) {
        return NO;
    }
    return YES;
}




#pragma mark 选择表情
-(void)selectEmoji:(UIButton*)button{
    if ((_emojiDelegate && [_emojiDelegate respondsToSelector:@selector(selectEmoji:)])) {
        [_emojiDelegate selectEmoji:button.tag];
    }
}

@end
