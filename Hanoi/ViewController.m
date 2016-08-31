//
//  ViewController.m
//  Hanoi
//
//  Created by WeShape_Design01 on 15/11/12.
//  Copyright © 2015年 Weshape3D. All rights reserved.
//

#import "ViewController.h"

#define KNUM 3
#define KCOMPLETE @"COMPLETE"

#define KSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define KColorBtnSpace 50.f
#define KColorBtnSize 30.f

#define KPlateSpace (KSCREENWIDTH/6.f)

#define KColmuWidth KPlateSpace

#define KPlateHeight 15.f

#define MAXPlateWidth  (KPlateSpace-10)
#define MINPlateWidth (KPlateHeight * 2)

@interface ViewController ()
{
    CGFloat downPos;
    NSMutableArray *stepArr;

    /**
      移动步数，从0开始
     */
    NSInteger steps;
    
    BOOL AIFlag;
    
    short plateNum;
    /**
     frome柱子
     */
    BOOL start;
    /**
     to柱子
     */
    BOOL end;

}
@end

@implementation ViewController

@synthesize columnA,columnB,columnC;

+(ViewController *)ShareVC{
    static ViewController *VC = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        VC = [[self alloc] init];
    });
    return VC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    stepArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"start");
    
    [self configNumBtn];
    
    [self configColorTool];
    
    [self configColumn];
 
    plateNum = KNUM;
    
    [self configHanoiWithNumber:plateNum];
    
    start = 0;
    end = 1;
    
    // 求助按钮
    UIButton *AIBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AIBtn.frame = CGRectMake(20, KSCREENHEIGHT - KColorBtnSpace, 80, KColorBtnSize);
    AIBtn.backgroundColor = [UIColor clearColor];
    
    AIBtn.layer.borderWidth = 2;
    AIBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    AIBtn.layer.cornerRadius = 4;
    AIBtn.layer.masksToBounds = YES;
    
    [AIBtn setTitle:@"AIHelp" forState:UIControlStateNormal];
    [AIBtn addTarget:self action:@selector(AIMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:AIBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notMethod) name:KCOMPLETE object:nil];
}

/*
 初始化柱子
 */
- (void)configColumn{
    columnA = [[Column alloc] init];
    columnB = [[Column alloc] init];
    columnC = [[Column alloc] init];
    
    NSArray *columns = @[columnA,columnB,columnC];
    NSArray *names = @[@"A",@"B",@"C"];
    
    for (short i=0; i<3; i++) {
        
        Column *column = (Column *)columns[i];
        
        column.col = i;
        
        column.name = names[i];
        
        column.frame = CGRectMake(0, KSCREENHEIGHT/5.f, KColmuWidth, 4/5.f * KSCREENHEIGHT - KColorBtnSpace - 20 );
        
        column.columnColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1];
        column.backgroundColor = [UIColor clearColor];

        column.center = CGPointMake(KPlateSpace * ((i << 1) + 1), column.center.y);
//        NSLog(@"frame:%@",column);
        
        
        [self.view addSubview:column];
        
        [column setNeedsDisplay];
        
    }
    
    // 横着的地板
    UIView *downColumn = [[UIView alloc] initWithFrame:CGRectMake(40, columnA.frame.origin.y + columnA.frame.size.height - 4, KSCREENWIDTH - 40 * 2, KPlateHeight)];
    downColumn.backgroundColor = columnA.columnColor;
    downColumn.layer.cornerRadius = 4;
    downColumn.layer.masksToBounds = YES;
    [self.view addSubview:downColumn];

    // 盘子的最底层
    downPos = downColumn.frame.origin.y;

}

/**
 初始化汉诺塔盘子
 */
- (void)configHanoiWithNumber:(int)number{
    
    CGFloat Difference = (MAXPlateWidth - MINPlateWidth)/(number);
    
    for (short i=0; i<number; i++) {
        HanoiPlate *plate = [[HanoiPlate alloc] initWithFrame:CGRectMake(0, 0, [self getWidthMAXWidth:MAXPlateWidth difference:Difference index:i], KPlateHeight)];

        plate.layer.cornerRadius = 4;
        plate.layer.borderWidth = 1;
        plate.layer.borderColor = [UIColor whiteColor].CGColor;
        plate.layer.masksToBounds = YES;
        
        plate.backgroundColor = [UIColor blackColor];
        
        plate.column = 0;
        plate.row = number - i;
        
        plate.tag = number - i;
        
        CGFloat xCenter = [plate getHanoiXPosWithSpace:KPlateSpace index:plate.column];
        CGFloat yCenter = [plate getHanoiYPosWithRelPos:downPos index:i];
        
        plate.center = CGPointMake(xCenter, yCenter);
        
        [self.view addSubview:plate];
        
        // 数据操作
        [columnA.plates insertObject:plate atIndex:0];
    }
}


#pragma mark 汉诺塔工具
// 获取宽度
- (CGFloat)getWidthMAXWidth:(CGFloat)MAX_Width difference:(CGFloat)difference index:(short)i{
    return MAX_Width - i * difference ;
}

#pragma mark 数量工具
- (void)configNumBtn{
    for (short i = 0; i < 7; i++) {
        NSArray *nums = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        
        UIButton *selectNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectNumBtn.backgroundColor = [UIColor clearColor];
        [selectNumBtn setTitle:[NSString stringWithFormat:@"%@",nums[i]] forState:UIControlStateNormal];
        selectNumBtn.tag = 100+i;
        selectNumBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
        
        selectNumBtn.frame = CGRectMake(20 + i * KColorBtnSpace , 20, KColorBtnSize, KColorBtnSize);
        
        selectNumBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        selectNumBtn.layer.borderWidth = 2;
        selectNumBtn.layer.cornerRadius = 4;
        selectNumBtn.layer.masksToBounds = YES;
        
        [selectNumBtn addTarget:self action:@selector(initplate:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:selectNumBtn];
    }
}

#pragma mark 颜色工具
- (void)configColorTool{
    NSArray *backColorArr = @[[UIColor darkGrayColor],[UIColor colorWithWhite:0.1 alpha:1],[UIColor colorWithRed:0.5 green:0.7 blue:0.6 alpha:1]];

    for (short i = 0; i < 3; i++) {
        UIButton *selectColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectColorBtn.backgroundColor = backColorArr[i];
        
        selectColorBtn.frame = CGRectMake((KSCREENWIDTH - (3-i) * KColorBtnSpace) , KSCREENHEIGHT - KColorBtnSpace, KColorBtnSize, KColorBtnSize);
        
        selectColorBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        selectColorBtn.layer.borderWidth = 2;
        selectColorBtn.layer.cornerRadius = 4;
        selectColorBtn.layer.masksToBounds = YES;
        
        [selectColorBtn addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:selectColorBtn];
        
    }
}

- (void)selectColor:(UIButton *)colorBtn{
    if (![self.view.backgroundColor isEqual:colorBtn.backgroundColor]) {

        [UIView animateWithDuration:0.3 animations:^{
            self.view.backgroundColor = colorBtn.backgroundColor;
        }];
    }
}

#pragma mark AIHELP Method
- (void)AIMethod{

    UIButton *b = (UIButton *)[self.view viewWithTag:100+plateNum-1];
    [self initplate:b];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AIFlag = YES;
        steps = 0;
        [self hanoiIndex:plateNum from:start *2 depend:2-1 to:end *2];
        [self notMethod];
    });
    
}

- (void)hanoiIndex:(short)index from:(short)fromeCol depend:(short)dependCol to:(short)toCol{
    if (index == 1) {
        [self moveIndex:1 from:fromeCol to:toCol];
        printf("%d  %d  ",fromeCol+1,toCol+1);
    }else{
        [self hanoiIndex:index - 1 from:fromeCol depend:toCol to:dependCol];
        [self moveIndex:index from:fromeCol to:toCol];
        printf("%d  %d  ",fromeCol+1,toCol+1);
        [self hanoiIndex:index-1 from:dependCol depend:fromeCol to:toCol];
    }
}

- (void)moveIndex:(short)index from:(short)frome to:(short)to{
    
    Column *fromobj,*toObj;
    switch (frome) {
        case 0:{
            fromobj = columnA;
        }break;
        case 1:{
            fromobj = columnB;
        }break;
        case 2:{
            fromobj = columnC;
        }break;
            
        default:
            break;
    }
    switch (to) {
        case 0:{
            toObj = columnA;
        }break;
        case 1:{
            toObj = columnB;
        }break;
        case 2:{
            toObj = columnC;
        }break;
            
        default:
            break;
    }

    [stepArr insertObject:fromobj atIndex:stepArr.count];
    [stepArr insertObject:toObj atIndex:stepArr.count];
}

// 通知相关的操作
- (void)notMethod{

    if (AIFlag) {
        
        if (steps<stepArr.count) {
            Column *col = (Column *)stepArr[steps];
            [col tap:nil];
            steps ++;
        }else{
            // AI移动完成  初始化
            
            // AI关闭
            AIFlag = NO;
            
            // 起始位置交换
            start = !start;
            end = !end;
            
            // 清空数组
            [stepArr removeAllObjects];
            steps = 0;
        }
        
        
    }
    
    
}



#pragma mark configPlates
- (void)initplate:(UIButton *)btn{
    [self removeplate];
    [columnB.plates removeAllObjects];
    [columnC.plates removeAllObjects];
    
    plateNum = (short)[btn.titleLabel.text integerValue];
    [self configHanoiWithNumber:plateNum];
    AIFlag = NO;
    start = 0;
    end = 1;
    steps = 0;
    self.raisedPlate = nil;
    columnA.topHanoi = nil;
}
- (void)removeplate{
    for (UIView *subv in self.view.subviews) {
        if (1<=subv.tag&&subv.tag<=plateNum) {
            [subv removeFromSuperview];
        }
    }
    [columnA.plates removeAllObjects];
    [stepArr removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
