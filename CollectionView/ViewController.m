//
//  ViewController.m
//  CollectionView
//
//  Created by macmini2 on 16/7/13.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import "ViewController.h"
#import "EmojiListView.h"
#import "AdaptiveTextView.h"
#import "EmojiInfo.h"
@interface ViewController ()<SelectDelegate>
{
    EmojiListView * emoji;
}
@property (weak, nonatomic) IBOutlet AdaptiveTextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


}
-(void)insertEmoticon:(EmojiInfo *)emojiInfo{
    if ([emojiInfo.emojiString isEqualToString:@"[删除]"]) {
        [self.textView deleteBackward];
    }else{
       [self.textView insertEmoticon:emojiInfo];
    }
    
    [self.textView resignFirstResponder];
}

- (IBAction)clieck:(id)sender {


    NSArray * nibs = [[NSBundle mainBundle]loadNibNamed:@"EmojiListView" owner:nil options:nil];
    emoji=[nibs objectAtIndex:0];
    emoji.frame= CGRectMake(0, 80, CGRectGetWidth(self.view.frame), 226);
    [self.view addSubview:emoji];
    emoji.emojiDelegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
