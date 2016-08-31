//
//  HanoiPlate.h
//  Hanoi
//
//  Created by WeShape_Design01 on 15/11/12.
//  Copyright © 2015年 Weshape3D. All rights reserved.
//

/**
 汉诺塔圆盘
 */

/**
 
 */

#import <UIKit/UIKit.h>

@interface HanoiPlate : UIView

/**
 盘子列数（柱子）
 */
@property (nonatomic,assign) int column;

/**
 盘子行数（层数）
 */
@property (nonatomic,assign) int row;

/**
 盘子中心横坐标 (center.x)
 */
@property (nonatomic,assign) CGFloat xCenter;

/**
 盘子中心纵坐标 (center.y)
 */
@property (nonatomic,assign) CGFloat yCenter;


- (CGFloat)getHanoiXPosWithSpace:(CGFloat)space index:(short)i;
- (CGFloat)getHanoiYPosWithRelPos:(CGFloat)RelPos index:(short)i;


@end
