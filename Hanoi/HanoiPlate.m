//
//  HanoiPlate.m
//  Hanoi
//
//  Created by WeShape_Design01 on 15/11/12.
//  Copyright © 2015年 Weshape3D. All rights reserved.
//

#import "HanoiPlate.h"

@implementation HanoiPlate

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
//+ (instancetype)buttonWithType:(UIButtonType)buttonType{
//    HanoiPlate *plate = [[HanoiPlate alloc] init];
//    plate.buttonType = UIButtonTypeCustom;
//    return plate;
//}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.column = 0;
        self.row = 0;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (CGFloat)getHanoiXPosWithSpace:(CGFloat)space index:(short)i{
    // 计算柱子center
    return space * ((i << 1) + 1);
}

- (CGFloat)getHanoiYPosWithRelPos:(CGFloat)RelPos index:(short)i{
    return RelPos - (i + 0.5f) * self.frame.size.height;
}


@end
