//
//  PaintView.m
//  TestForFeedback
//
//  Created by Shane on 2019/9/4.
//  Copyright © 2019 Shane. All rights reserved.
//

#import "PaintView.h"



@implementation PaintView
{
    CAShapeLayer *_shapeLayer;
    CGMutablePathRef _path;
    NSMutableArray *_pathArray;
    UIColor *_lineColor;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviewsAndInitData];
        _lineColor = [UIColor redColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupSubviewsAndInitData];
}

- (void)setupSubviewsAndInitData
{
    _pathArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)setScreenshotImage:(UIImage *)screenshotImage
{
    self.layer.contents = (id)screenshotImage.CGImage;
}

#pragma mark - Touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    _path = CGPathCreateMutable();
    CGPathMoveToPoint(_path, NULL, p.x, p.y);
    
    CAShapeLayer * slayer = [CAShapeLayer layer];
    slayer.path = _path;
    slayer.lineWidth = 2;
    slayer.fillColor = [UIColor clearColor].CGColor;
    slayer.strokeColor = _lineColor.CGColor;
    // 略：设置 slyer 参数
    [self.layer addSublayer:slayer];
    _shapeLayer = slayer;
    
    [_pathArray addObject:slayer];
    !self.PaintViewPaintingBlock?:self.PaintViewPaintingBlock(YRFeedBackPaintStateBegin);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    //略：point有效值判断
    if ([self.layer containsPoint:p]) {
//        NSLog(@"yes");
    } else {
//        NSLog(@"no");
    }
    //点加至线上
    CGPathAddLineToPoint(_path, NULL, p.x, p.y);
    _shapeLayer.path = _path;
    !self.PaintViewPaintingBlock?:self.PaintViewPaintingBlock(YRFeedBackPaintStateMove);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    !self.PaintViewPaintingBlock?:self.PaintViewPaintingBlock(YRFeedBackPaintStateCancel);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    !self.PaintViewPaintingBlock?:self.PaintViewPaintingBlock(YRFeedBackPaintStateEnd);
}


- (void)changeColor:(UIColor *)color{
    _lineColor = color;
}

- (void)revoke
{
    [_pathArray.lastObject removeFromSuperlayer];
    [_pathArray removeLastObject];
}
- (void)revokeAll{
    for (CALayer *layer in _pathArray) {
        [layer removeFromSuperlayer];
    }
    [_pathArray removeAllObjects];
}
@end

@implementation UIView (ConvertToImage)

//使用该方法不会模糊，根据屏幕密度计算
- (UIImage *)convertViewToImage {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

@end
