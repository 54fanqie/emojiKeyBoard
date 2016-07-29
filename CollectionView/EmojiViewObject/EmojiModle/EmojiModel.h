//
//  EmojiModel.h
//  CollectionView
//
//  Created by macmini2 on 16/7/19.
//  Copyright © 2016年 emiage. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EmojiModel : NSObject

+(NSMutableArray*)emojiInfoInWithBundleName:(NSString*)bundleName plistName:(NSString*)plistName;

@end
