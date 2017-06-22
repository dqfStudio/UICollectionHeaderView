//
//  MGSegmentView.h
//  UICollectionHeaderView
//
//  Created by dqf on 2017/6/22.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGSegmentViewDelegate <NSObject>

@optional
- (void)headerSelectedIndex:(NSInteger)index selectedTitle:(NSString *)title;
- (void)segSelectedIndex:(NSInteger)index selectedTitle:(NSString *)title segTag:(NSInteger)tag;

@end

@interface MGSegmentView : UIView <MGSegmentViewDelegate>

@property(nonatomic, assign) id<MGSegmentViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame hTitle:(NSArray *)hTitles bTitle:(NSArray *)bTitles;

@end
