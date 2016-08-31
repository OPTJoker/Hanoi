//
//  Column.h
//  Hanoi
//
//  Created by WeShape_Design01 on 15/11/12.
//  Copyright © 2015年 Weshape3D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HanoiPlate.h"


@interface Column : UIView

@property (nonatomic,retain) NSMutableArray *plates;

@property (nonatomic,strong) HanoiPlate *topHanoi;

@property (nonatomic,copy) UIColor *columnColor;

@property (nonatomic,copy) NSString *name;

/**
 当前柱子的col;
 */
@property (nonatomic,assign) short col;

/**
 是否有盘子在抬起状态
 */
//@property (nonatomic,assign) BOOL isRaised;

///**
// 记录抬起的frame
// */
//@property (nonatomic,assign) CGRect oldFrame;
- (void)tap:(UITapGestureRecognizer *)tap;

@end
