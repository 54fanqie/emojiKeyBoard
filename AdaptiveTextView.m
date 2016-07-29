//
//  AdaptiveTextView.m
//  Part of Chat
//
//  Created by macmini2 on 16/7/14.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import "AdaptiveTextView.h"
#import "EmojiInfo.h"
@interface AdaptiveTextView()<UITextViewDelegate>
// 最大和最小高度，根据行数、contentInset计算而来
@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat containerInset;
@property (nonatomic, assign) CGFloat currentHeight;
@end


@implementation AdaptiveTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        _maxNumberOfLines = 3;
        [self commonInitialiser];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _maxNumberOfLines = 3;
        [self commonInitialiser];
    }
    return self;
}


-(void)commonInitialiser{
    [self sizeToFit];
    self.bounces = NO;
    self.delegate=self;
    // 是否非连续布局属性 防止输入上下抖动
    self.layoutManager.allowsNonContiguousLayout = NO;
    self.enablesReturnKeyAutomatically = NO;
    _containerInset =self.textContainerInset.top + self.textContainerInset.bottom;
    
    //最小行数高度会根据字体font而改变的
    _minHeight = [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)].height;
    //根据默认获取到一行时候的高度（也就是最小高度)
    self.currentHeight = _minHeight;
    //设置最大行数(这里已经把偏移量减去了)
    _maxHeight = (_minHeight- _containerInset) * _maxNumberOfLines+_containerInset;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (_delegete && [_delegete respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [_delegete textViewDidBeginEditing:self];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    CGFloat needHeight = [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)].height;
    CGFloat internalViewNewHeight = MIN(MAX(needHeight, _minHeight), _maxHeight);
    //当大于限制行数才能滚动
    if (internalViewNewHeight >= _maxHeight) {
        if(!self.scrollEnabled){
            self.scrollEnabled = YES;
        }
    } else {
        if (self.scrollEnabled) {
            self.scrollEnabled = NO;
        }
    }
    if (ceilf(_currentHeight) != ceilf(internalViewNewHeight)) {
        self.currentHeight = internalViewNewHeight;
        if ([self.delegete respondsToSelector:@selector(textView:shouldChangeHeight:)]) {
            [self.delegete textView:self shouldChangeHeight:internalViewNewHeight];
        }
    }
    
}


-(void)textViewDidChangeSelection:(UITextView *)textView{
    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}




- (void)insertEmoticon:(EmojiInfo *)emoticon {
    //    NSString *imageStr = emoticon.imageStr;
    //    if (imageStr) {
    //        [self replaceRange:self.selectedTextRange withText:imageStr];
    //        return;
    //    }
    // png图片处理
    if (emoticon.emojiImage == nil) {
        return;
    }
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = emoticon.emojiImage;
    
    // 1.对输入图片的高度做处理,保持和字体大小一样
    CGFloat emoticonH = self.font.lineHeight;
    attachment.bounds = CGRectMake(0, -4, emoticonH, emoticonH);
//     [self.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:self.selectedRange.location];
    
    
    // 2.获取可变输入文本,并且设置属性
    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [strM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, 1)];
    
    // 3.获取文本框中可变属性
    NSMutableAttributedString *textM = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange lastRange = self.selectedRange;
    NSRange replaceRange = NSMakeRange(lastRange.location + 1, 0);

    [textM insertAttributedString:strM atIndex:lastRange.location];
//    [textM replaceCharactersInRange:lastRange withAttributedString:strM];
    self.attributedText = textM;
    self.selectedRange = replaceRange;
}

- (NSString *)attrStr {
    // 1.获取textView的属性文本
    NSAttributedString *textAttr = self.attributedText;
    NSMutableString *strM = [NSMutableString string];
    
    // 2.因为textView的属性文本是分段存储的,所以遍历该文本
    [textAttr enumerateAttributesInRange:NSMakeRange(0, textAttr.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        // 2.1.如果是图片,字典中会有NSAttachment这个键值对
        NSTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) {
//            [strM appendString:attachment.chs]
        } else {  // 使用range获取字符串(包括emoji也算是字符串)
            NSString *str = [textAttr.string substringWithRange:range];
            [strM appendString:str];
        }
    }];
    return strM;
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
