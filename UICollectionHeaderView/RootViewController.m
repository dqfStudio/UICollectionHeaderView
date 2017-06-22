//
//  RootViewController.m
//  UICollectionHeaderView
//
//  Created by dqf on 2017/6/22.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "RootViewController.h"
#import "XLPlainFlowLayout.h"
#import "MGSegmentView.h"

typedef NS_ENUM(NSInteger, NSHeaderStatus) {
    NSHeaderStatusHidden = 0,
    NSHeaderStatusShow,
};


@interface RootViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGRect oldFrame;
    CGRect newFrame;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *toolbar;

@property (strong, nonatomic) MGSegmentView *segmentView;
@property (assign, nonatomic) NSHeaderStatus headerStatus;

@end

@implementation RootViewController

static NSString * const cellIndentifier = @"cellIndentifier";

- (UIButton *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIButton alloc] init];
        [_toolbar setFrame:CGRectMake(0, 64, 320, 50)];
        [_toolbar setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [_toolbar setTitle:@"筛选" forState:UIControlStateNormal];
        [_toolbar addTarget:self action:@selector(tapGestureRecognizerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpViews];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    
    oldFrame  = CGRectMake(0, -40*(3+1), CGRectGetWidth([UIScreen mainScreen].bounds), 40*(3+1));
    newFrame  = CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), 40*(3+1));
    
    self.segmentView = [[MGSegmentView alloc] initWithFrame:oldFrame hTitle:@[@"演唱会回看",@"精彩瞬间",@"明星专访",@"粉丝聚焦"] bTitle:@[@[@"艺人",@"全部",@"刘德华",@"张学友"],@[@"时间",@"全部",@"2017",@"2016"],@[@"排序",@"全部",@"最新",@"热门"]]];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(40*(3+1), 0, 0, 0);
    [self.collectionView addSubview:self.segmentView];
    
}

- (void)setUpViews{
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
//    layout.itemSize = CGSizeMake(100, 100);
    layout.itemSize = CGSizeMake(320, 230);
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.naviHeight = 40;
    self.collectionView.collectionViewLayout =layout;
    self.collectionView.delegate =self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12*3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)tapGestureRecognizerAction:(id)sender
{
    self.headerStatus = NSHeaderStatusShow;
    [self.segmentView removeFromSuperview];
    self.segmentView.frame = newFrame;
    [UIView animateWithDuration:0.3 animations:^{
        [self.toolbar removeFromSuperview];
        [self.view addSubview:self.segmentView];
    }];
}

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.headerStatus == NSHeaderStatusShow) {
        self.headerStatus = NSHeaderStatusHidden;
        if ([self.view.subviews containsObject:self.segmentView]) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.segmentView removeFromSuperview];
            }];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > -64) {
        
        [UIView animateWithDuration:0.3 animations:^{
            if (![self.view.subviews containsObject:self.toolbar]) {
                [self.view addSubview:self.toolbar];
            }
        }];
        
    }else {
        if ([self.view.subviews containsObject:self.toolbar]) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.toolbar removeFromSuperview];
            }];
        }
        
        if (![self.view.subviews containsObject:self.segmentView]) {
            if (![NSStringFromCGRect(self.segmentView.frame) isEqualToString:NSStringFromCGRect(oldFrame)]) {
                self.segmentView.frame = oldFrame;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.collectionView addSubview:self.segmentView];
                }];
            }
        }

    }

}

@end
