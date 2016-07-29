//
//  EmojiListView.h
//  CollectionView
//
//  Created by macmini2 on 16/7/18.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import "EmojiListView.h"
#import "EmojiModel.h"
#import "EmojiInfo.h"
#import "EmojiScrollViewModel.h"


#define itemsBackGroundColor [UIColor colorWithRed:235/255.0 green:235/255.0 blue:242/255.0 alpha:1]

@interface EmojiListView ()<UIScrollViewDelegate,SelectEmojiDelegate>
@property (weak, nonatomic)  IBOutlet UIScrollView * moreEmojiScro;

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic,strong) NSMutableArray * typesEmoji;
@property (nonatomic,strong) NSMutableArray *  pageMu;
@property (nonatomic,strong) EmojiScrollViewModel * mojiScrollViewModel;
@property (nonatomic,strong) NSMutableArray * allEmojis;

@property (nonatomic,assign) CGFloat lastOffSetX;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) BOOL stopScr;

@property (nonatomic,strong) NSMutableArray * tabbarItems;
@end



@implementation EmojiListView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        /* logo ：底部按钮图片
         * bundle  表情资源
         * plist  表情plist文件（最好格式是一样的 这样解析的时候就不用麻烦了）
         */
        
        //这里是根据需求 添加想要的表情分类（例如：经典的、新浪的、apple的）
        NSDictionary *dic4  =@{@"logo":@"lxh",@"bundle":@"Sina_lxh",@"plist":@"langxiaohua.plist"};
        NSDictionary *dic3  =@{@"logo":@"sina",@"bundle":@"Emotion",@"plist":@"Emotion.plist"};
        NSDictionary *dic2  =@{@"logo":@"grinning",@"bundle":@"ClassicFace",@"plist":@"ClassicFace.plist"};
        
        //苹果原生表情 因网上获取的plist的文件不同所以需要解析方式也不同 我就没添加上去
        
        //        NSDictionary *dic1  =@{@"logo":@"emoji",@"bundle":@"AppleEmoji",@"plist":@"AppleEmojisList.plist"};
        self.typesEmoji=[NSMutableArray arrayWithObjects:dic2,dic3,dic4,nil];
    }
    return self;
}

-(void)awakeFromNib{
    //创建表情视图
    self.backScrollView.delegate=self;
    [self.backScrollView layoutIfNeeded];
    [self bringSubviewToFront:self.pageControl];
    
    //创建tabbar
    [self creatEmojiTabbarView];
    //每组分区表情有多少分页
    self.pageMu = [NSMutableArray array];
    //默认进入第一个分区
    self.section = 0;
    self.stopScr = NO;
}


-(void)layoutSubviews{
    
    if (!self.mojiScrollViewModel) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self initEmojiList:CGRectGetWidth(self.frame)];
        });
        
    }
}
-(void)initEmojiList:(CGFloat)width{
    
    self.mojiScrollViewModel= [[EmojiScrollViewModel alloc]init];
    self.mojiScrollViewModel.emojiDelegate =self;
    for (NSInteger i=0;i<self.typesEmoji.count;i++) {
        NSDictionary * dic = self.typesEmoji[i];
        //获取本地表情包
        NSMutableArray * emojiArray = [NSMutableArray arrayWithArray:[EmojiModel emojiInfoInWithBundleName:dic[@"bundle"] plistName:dic[@"plist"]]];
        
        UIScrollView * scro = [[UIScrollView alloc]initWithFrame:CGRectMake(i*width, 0, width, CGRectGetHeight(self.frame))];
        scro.bounces=NO;
        scro.pagingEnabled=YES;
        scro.showsHorizontalScrollIndicator=NO;
        scro.delegate=self;
        scro.tag=120+i;
        
        scro.canCancelContentTouches = NO;//是否可以中断touches
        scro.delaysContentTouches = NO;//是否延迟touches事件
        CGRect frame =scro.frame;
        frame.size.width=self.frame.size.width;
        scro.frame=frame;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mojiScrollViewModel scrollViewLayoutWithEmojiArray:emojiArray inView:scro completionBlock:^(NSArray * emojiImages,NSInteger pageCount) {
                [self.pageMu addObject:[NSNumber numberWithInteger:pageCount]];
                self.pageControl.numberOfPages = [self.pageMu[0] integerValue];
                if (!self.allEmojis) {
                    self.allEmojis = [NSMutableArray array];
                }
                [self.allEmojis addObject:emojiImages];
            }];
            [self.backScrollView addSubview:scro];
            
        });
    }
    
    self.backScrollView.contentSize = CGSizeMake(self.typesEmoji.count*width, 0);
    
}


#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x==0 && (scrollView.tag == 120 || scrollView.tag == 0)) {
        self.stopScr =YES;
    }else{
        self.stopScr =NO;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!self.stopScr) {
        if (scrollView.tag == 0) {
            self.section = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
            [self.pageControl setNumberOfPages:[self.pageMu[_section] integerValue]];
            if (_lastOffSetX >= scrollView.contentOffset.x) {//往右滑动
                NSLog(@"往右滑动");
                [self.pageControl setCurrentPage:[self.pageMu[_section] integerValue]];
            }else{//往左滑动
                [self.pageControl setCurrentPage:0];
                NSLog(@"往左滑动");
            }
            _lastOffSetX = scrollView.contentOffset.x;
            
            UIButton * selectBtn = self.tabbarItems[_section];
            for (UIButton * itemButton in self.tabbarItems) {
                if (itemButton.tag == selectBtn.tag) {
                    [itemButton setBackgroundColor:itemsBackGroundColor];
                }else{
                    [itemButton setBackgroundColor:[UIColor whiteColor]];
                }
            }
        }else{
            NSInteger index = fabs(scrollView.contentOffset.x) / CGRectGetWidth(self.frame);
            [self.pageControl setCurrentPage:index];
        }
    }
}
// 选择表情
-(void)selectEmoji:(NSInteger)index{
    
    EmojiInfo * emojiInfo = self.allEmojis[_section][index];
    if (_emojiDelegate && [_emojiDelegate respondsToSelector:@selector(insertEmoticon:)]) {
        [_emojiDelegate insertEmoticon:emojiInfo];
    }
    
}






















#pragma mark 添加表情 emoji表情 收藏的表情 土巴兔
-(void)creatEmojiTabbarView{
    //这里在ScrollerView中创建你想要的表情分类
    for (NSInteger i=0;i<self.typesEmoji.count;i++) {
        NSDictionary * dic = self.typesEmoji[i];
        UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame=CGRectMake(i*buttonWidth+i*1, 0, buttonWidth, CGRectGetHeight(self.moreEmojiScro.frame));
        [itemButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"logo"]]] forState:UIControlStateNormal];
        itemButton.imageEdgeInsets =  UIEdgeInsetsMake(buttonEdgeInsetTop, buttonEdgeInsetLeft, buttonEdgeInsetBottom, buttonEdgeInsetRight);
        [itemButton addTarget:self action:@selector(otherEmojiAction:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i+10000;
        [self.moreEmojiScro addSubview:itemButton];
        //默认
        if (i==0) {
            [itemButton setBackgroundColor:itemsBackGroundColor];
        }
        if(!self.tabbarItems){
            self.tabbarItems = [NSMutableArray array];
        }
        [self.tabbarItems addObject:itemButton];
    }
    self.moreEmojiScro.contentSize = CGSizeMake(self.typesEmoji.count*buttonWidth, 0);
}




-(void)otherEmojiAction:(UIButton*)button{
    for (UIButton * itemButton in self.tabbarItems) {
        if (itemButton.tag == button.tag) {
            [itemButton setBackgroundColor:itemsBackGroundColor];
        }else{
            [itemButton setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    [self.pageControl setNumberOfPages:[self.pageMu[button.tag-10000] integerValue]];
    [self.pageControl setCurrentPage:0];
    
    [self.backScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*(button.tag -10000), 0) animated:YES];
    
    self.section=button.tag-10000;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
