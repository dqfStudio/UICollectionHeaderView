//
//  MGSegmentView.m
//  UICollectionHeaderView
//
//  Created by dqf on 2017/6/22.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "MGSegmentView.h"
#import "MGSegmentedControl.h"

#define KDefaultH   40

@interface MGSegmentView ()

//header  titles
@property (nonatomic, strong) NSMutableArray *hTitleArr;
//body titles
@property (nonatomic, strong) NSMutableArray *bTitleArr;

@end

@implementation MGSegmentView

- (NSMutableArray *)hTitleArr
{
    if (!_hTitleArr) {
        _hTitleArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _hTitleArr;
}

- (NSMutableArray *)bTitleArr
{
    if (!_bTitleArr) {
        _bTitleArr = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _bTitleArr;
}

- (id)initWithFrame:(CGRect)frame hTitle:(NSArray *)hTitles bTitle:(NSArray *)bTitles
{
    self = [super initWithFrame:frame];
    if (self) {
        if (bTitles.count > 0) {
            [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
            
            
            if (self.hTitleArr.count > 0) [self.hTitleArr removeAllObjects];
            [self.hTitleArr addObjectsFromArray:hTitles];
            
            if (self.bTitleArr.count > 0) [self.bTitleArr removeAllObjects];
            [self.bTitleArr addObjectsFromArray:bTitles];
            
            
            //header  titles
            [self loadHSegViewWithTitles:hTitles];
            
            
            //body titles
            for (int i=0; i<bTitles.count; i++) {
                
                MGSegmentedControl *segControl = [self loadBSegViewWithTitles:bTitles[i] tag:i];
                segControl.frame = CGRectMake(0, KDefaultH*(i+1), CGRectGetWidth(self.frame), KDefaultH);
                [self addSubview:segControl];
            }
        }
    }
    return self;
}

- (void)loadHSegViewWithTitles:(NSArray *)titles
{
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setFrame:CGRectMake(0, 0, viewWidth, 40)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:[UIColor redColor]];
    [imageView setFrame:CGRectMake(0, 32, 10, 5)];
    [bgView addSubview:imageView];
    
    MGSegmentedControl *segControl = [[MGSegmentedControl alloc] initWithSectionTitles:titles];
    segControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segControl.frame = CGRectMake(0, 0, viewWidth, 30);
    segControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    
    segControl.selectedSegmentIndex = 0;
    
    [segControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        
        if (index == segmentedControl.selectedSegmentIndex) {
            CGRect frame = imageView.frame;
            frame.origin.x = index*(viewWidth/4)+(viewWidth/4)/2-imageView.frame.size.width/2;
            imageView.frame = frame;
        }
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        return attString;
    }];
    
    [segControl addTarget:self action:@selector(hSegChangedValue:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:segControl];
    
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setFrame:CGRectMake(0, 39, viewWidth, 1)];
    [lineView setBackgroundColor:[UIColor blackColor]];
    [bgView addSubview:lineView];
    
}

- (MGSegmentedControl *)loadBSegViewWithTitles:(NSArray *)titles tag:(NSInteger)tag
{
    // Segmented control with scrolling
    MGSegmentedControl *segControl = [[MGSegmentedControl alloc] initWithSectionTitles:titles];
    segControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    segControl.tag = tag;
    
    segControl.selectedSegmentIndex = 1;
    segControl.selectedIndex = segControl.selectedSegmentIndex;
    
    
    [segControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        
        if (index == 0) {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            return attString;
        }else {
            
            if (selected) {
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
                return attString;
            }else {
                
                if (segControl.selectedIndex == index) {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
                    return attString;
                }else {
                    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
                    return attString;
                }
            }
        }
        
    }];
    
    [segControl addTarget:self action:@selector(bSegChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    return segControl;
    
}


- (void)hSegChangedValue:(MGSegmentedControl *)segmentedControl {
    
    NSString *title = self.hTitleArr[segmentedControl.selectedSegmentIndex];
    
    if ([self.delegate respondsToSelector:@selector(headerSelectedIndex:selectedTitle:)]) {
        [self.delegate headerSelectedIndex:segmentedControl.selectedSegmentIndex selectedTitle:title];
    }
}


- (void)bSegChangedValue:(MGSegmentedControl *)segmentedControl {
    
    if (segmentedControl.selectedSegmentIndex != 0) {
        segmentedControl.selectedIndex = segmentedControl.selectedSegmentIndex;
        
        NSArray *arr = self.bTitleArr[segmentedControl.tag];
        NSString *title = arr[segmentedControl.selectedSegmentIndex-1];
        
        if ([self.delegate respondsToSelector:@selector(segSelectedIndex:selectedTitle:segTag:)]) {
            [self.delegate segSelectedIndex:segmentedControl.selectedSegmentIndex-1 selectedTitle:title segTag:segmentedControl.tag];
        }
    }
}

@end
