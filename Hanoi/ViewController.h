//
//  ViewController.h
//  Hanoi
//
//  Created by WeShape_Design01 on 15/11/12.
//  Copyright © 2015年 Weshape3D. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HanoiPlate.h"

#import "Column.h"

@interface ViewController : UIViewController
/**
 柱子A
 */
@property (nonatomic,strong) Column *columnA;

/**
 柱子B
 */
@property (nonatomic,strong) Column *columnB;

/**
 柱子C
 */
@property (nonatomic,strong) Column *columnC;

/**
 升起的盘子
 */
@property (nonatomic,strong) HanoiPlate *raisedPlate;

/**
 升起盘子的柱子
 */
//@property (nonatomic,strong) Column *raisedColoumn;

/**
 可以使用AI
 */
//@property (nonatomic,assign) BOOL canAI;

+(ViewController *)ShareVC;

@end

