//
//  Column.m
//  Hanoi
//
//  Created by WeShape_Design01 on 15/11/12.
//  Copyright © 2015年 Weshape3D. All rights reserved.
//

#import "Column.h"
#import "ViewController.h"

#define KTOP 50

#define KCOMPLETE @"COMPLETE"

#define cenWidth 10.f

#define KSCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define KPlateSpace (KSCREENWIDTH/6.f)

//#define KColmuWidth KPlateSpace

#define KPlateHeight 15.f

#define MAXPlateWidth  (KPlateSpace-10)
#define MINPlateWidth (KPlateHeight * 2)

@implementation Column
{
    CGFloat downPos;
    
    UILabel *showLab;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.plates = [[NSMutableArray alloc] initWithCapacity:0];
        
        
     
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    downPos = self.frame.origin.y + self.frame.size.height - 4;
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - cenWidth)/2.f, 0, cenWidth, self.frame.size.height)];
    centerView.backgroundColor = self.columnColor;
    
    centerView.layer.cornerRadius = 4;
    centerView.layer.masksToBounds = YES;
    
    [self addSubview:centerView];
}
#pragma mark 手势
- (void)tap:(UITapGestureRecognizer *)tap{
    
    // 如果有盘子
    ViewController *vc = [ViewController ShareVC];
    // 抬起盘子
    if (!vc.raisedPlate) {
        if (self.plates.count) {
            HanoiPlate *plate = (HanoiPlate *)self.plates[0];
            [self raiseAnimation:plate gesture:tap];
        }
    }else{// 放下盘子
        [self raiseAnimation:vc.raisedPlate gesture:tap];
    }
    
}

#pragma mark 栈操作
/**
 数据出栈
 */
- (HanoiPlate *)popPlate{
    if (self.plates.count) {
        
        HanoiPlate *plate = self.plates[0];
        
        ViewController *vc = [ViewController ShareVC];
        vc.raisedPlate = plate;
        
        [self.plates removeObjectAtIndex:0];
        if (self.plates.count) {
            self.topHanoi = self.plates[0];
        }else{
            self.topHanoi = nil;
        }
        return plate;
    }
    return nil;
}

/**
 数据压栈
 */
- (void)pushPlate:(HanoiPlate *)plate{
    [self.plates insertObject:plate atIndex:0];
    self.topHanoi = plate;
    
    ViewController *vc = [ViewController ShareVC];
    vc.raisedPlate = nil;
}



/**
 弹起动画
 */
- (void)raiseAnimation:(HanoiPlate *)plate gesture:(UITapGestureRecognizer *)tap{
    ViewController *vc = [ViewController ShareVC];
    
    if (!vc.raisedPlate) {
        if (self.plates.count) {
            [UIView animateWithDuration:0.2 animations:^{
                plate.frame = CGRectMake(plate.frame.origin.x, KTOP, plate.frame.size.width, plate.frame.size.height);
            } completion:^(BOOL finished) {
                [self popPlate];
                if (!tap) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KCOMPLETE object:nil];
                }
                
            }];
            
        }
    }else{  // 放下 操作 动画
        
        if (self.topHanoi.tag > vc.raisedPlate.tag || !self.plates.count) {
        
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat xPos = [self getHanoiXPosWithSpace:KPlateSpace index:self.col];
                plate.center = CGPointMake(xPos, plate.center.y);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGFloat xPos = [self getHanoiXPosWithSpace:KPlateSpace index:self.col];
                    CGFloat yPos;
                    
                    yPos = [self getHanoiYPosWithRelPos:downPos index:self.plates.count];
                    
                    
                    plate.center = CGPointMake(xPos, yPos);
                    
                    [self pushPlate:vc.raisedPlate];
                    
//                    NSLog(@"落后%ld",self.plates.count);
                    
                    if (!tap) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KCOMPLETE object:nil];
                    }
                }];
            }];
        }
    }
    
//    self.isRaised = !self.isRaised;
}

/**
 */



- (CGFloat)getHanoiXPosWithSpace:(CGFloat)space index:(short)i{
    // 计算柱子center
    return space * ((i << 1) + 1);
}

- (CGFloat)getHanoiYPosWithRelPos:(CGFloat)RelPos index:(short)i{
    return RelPos - (i + 0.5f) * KPlateHeight;
}
@end
