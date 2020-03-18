//
//  YRFeedbackViewController.m
//  YRUI
//
//  Created by 崔昌云 on 2020/3/12.
//  Copyright © 2020 CCY. All rights reserved.
//

#import "YRFeedbackViewController.h"
#import "PaintView.h"
#import "NerdyUI.h"
#import "QMUIKit.h"
#import "YRFeedbackActionManager.h"
#import "NSBundle+YRFeedback.h"
#import "UIView+ConvertToImage.h"

typedef enum : NSUInteger {
    YRFeedbackCancel,
    YRFeedbackSend,
    YRFeedbackChangeColor,
    YRFeedbackChangeDelete,
    YRFeedbackChangeEditText,
} YRFeedbackAction;

typedef void (^YRFeedbackActionBlock)(YRFeedbackAction);
typedef void (^YRFeedbackActionBlock)(YRFeedbackAction);

@interface YRFeedbackPopColorView : QMUIPopupContainerView
@property (nonatomic,copy) void(^YRFeedbackChangeColorBlock)(NSString *colorName);
@property (nonatomic,weak) UIButton *chooseBtn;
@end

@implementation YRFeedbackPopColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsZero;
        NSArray *colorList = @[@"red",@"34,96,151,1",@"88,190,34",@"gray",@"orange",@"white"];
        NSMutableArray *btnList = @[NERSpring].mutableCopy;
        UIButton *chooseButton;
        for (NSString *color in colorList) {
            UIButton *button = [self colorButtonWithColor:color];
            [btnList addObject:button];
            if (!chooseButton) {
                chooseButton = button;
            }
        }
        [btnList addObject:NERSpring];
        [NERStack horizontalStackWithItems:btnList].embedIn(self.contentView).centerAlignment.gap(12);
        
        self.bgColor(@"35,35,35");
        
        UIImage *image = [NSBundle yr_feedbackimageWithName:@"feedback_ic_dagou"];
        chooseButton.img(Img(image).resize(20,20));
        
        _chooseBtn = chooseButton;
    }
    return self;
}

- (CGSize)sizeThatFitsInContentView:(CGSize)size {
    return CGSizeMake(300, 50);
}

- (UIButton *)colorButtonWithColor:(NSString *)color{
    UIButton *button = Button.bgColor(color).fixWH(36,36).borderRadius(18);
    button.layer.borderWidth = 2;
    button.layer.borderColor = Color(@"white").CGColor;
    
    View.fixWH(18,36).bgColor(@"0,0,0,0.2").addTo(button).makeCons(^{
        make.top.left.equal.constants(0);
    });
    button.onClick(^{
        !self.YRFeedbackChangeColorBlock?:self.YRFeedbackChangeColorBlock(color);
        [self hideWithAnimated:YES];
        [self buttonOnChoose:button];
    });
    return button;
}
- (void)buttonOnChoose:(UIButton *)button{
    _chooseBtn.img(@"clear");
    UIImage *image = [NSBundle yr_feedbackimageWithName:@"feedback_ic_dagou"];
    button.img(Img(image).resize(20,20));
    _chooseBtn = button;
}
@end

@interface YRFeedbackView : UIView
@property (nonatomic,copy) YRFeedbackActionBlock navActionBlock;
@property (nonatomic,copy) YRFeedbackActionBlock bottomActionBlock;
@property (nonatomic,copy) void(^YRFeedBackViewDidLayoutSubviewsBlock)(void);
@property (nonatomic,copy) void(^YRFeedbackChangeColorBlock)(NSString *colorName);
@property (nonatomic,copy) void(^YRFeedbackInputStateBlock)(BOOL showState);
@property (nonatomic,strong) YRFeedbackPopColorView *popChangeColorView;
@property (nonatomic,strong) UITextView *textView;
@end

@implementation YRFeedbackView
- (instancetype)initNavHeader
{
    self = [super init];
    if (self) {
        self.bgColor(@"40,40,40,1");
        
        id btnStyle = Style().fixWH(80,34).borderRadius(4).color(@"white").fnt(16).bgColor(@"black");
        int contentH = 50;
        
        UIButton *cancel = Button.str(@"取消").styles(btnStyle);
        UILabel *titleLabel = Label.str(@"反馈").color(@"white");
        UIButton *send = Button.str(@"发送").styles(btnStyle);
        
        UIView *contentView = View;
        
        contentView.addTo(self).makeCons(^{
            make.bottom.left.right.equal.constants(0);
            make.height.equal.constants(contentH);
        });
        
        HorStack(
                 @(10),
                 cancel,
                 NERSpring,
                 titleLabel,
                 NERSpring,
                 send,
                 @(10)
                 ).embedIn(contentView).centerAlignment;
        
        self.fixHeight(contentH+StatusBarHeight);
        
        cancel.onClick(^{
            !self.navActionBlock?:self.navActionBlock(YRFeedbackCancel);
        });
        send.onClick(^{
            !self.navActionBlock?:self.navActionBlock(YRFeedbackSend);
        });
    }
    return self;
}
- (instancetype)initBottomAction
{
    self = [super init];
    if (self) {
        WeakifySelf()
        int contentH = 50;
        int saveBottom = SafeAreaInsetsConstantForDeviceWithNotch.bottom;
        
        self.bgColor(@"40,40,40,1");
        id btnStyle = Style().fixWH(80,34).color(@"white");
        
        UIButton *changeColor = Button.img([NSBundle yr_feedbackimageWithName:@"feedback_ic_tiaose"]).styles(btnStyle);
        UIButton *editText = Button.img([NSBundle yr_feedbackimageWithName:@"feedback_ic_bianji"]).styles(btnStyle);
        UIButton *delete = Button.img([NSBundle yr_feedbackimageWithName:@"feedback_ic_delete"]).styles(btnStyle);
        UIView *colorView = View.fixWH(40,6).bgColor(@"red").borderRadius(2);
        colorView.layer.borderColor = Color(@"white").CGColor;
        colorView.layer.borderWidth = 2;
        
        UIView *contentView = View;
        
        contentView.addTo(self).makeCons(^{
            make.top.left.right.equal.constants(0);
            make.height.equal.constants(contentH);
        });
        colorView.addTo(changeColor).makeCons(^{
            make.bottom.equal.superview.bottom.constants(4).End();
            make.centerX.equal.superview.centerX.End();
        });
        
        HorStack(
                 @(10),
                 changeColor,
                 NERSpring,
                 editText,
                 NERSpring,
                 delete,
                 @(10),
                 ).embedIn(contentView).centerAlignment;
        
        self.fixHeight(contentH+saveBottom);
        
        changeColor.onClick(^{
            !self.bottomActionBlock?:self.bottomActionBlock(YRFeedbackChangeColor);
        });
        editText.onClick(^{
            !self.bottomActionBlock?:self.bottomActionBlock(YRFeedbackChangeEditText);
        });
        delete.onClick(^{
            !self.bottomActionBlock?:self.bottomActionBlock(YRFeedbackChangeDelete);
        });
        
        [self setYRFeedbackChangeColorBlock:^(NSString *colorName) {
            colorView.bgColor(colorName);
        }];
        
        [self setYRFeedBackViewDidLayoutSubviewsBlock:^{
            weakSelf.popChangeColorView.sourceRect = [changeColor convertRect:changeColor.bounds toView:nil];
        }];
    }
    return self;
}

- (instancetype)initInputView
{
    self = [super init];
    if (self) {
        
        int normalH = 80+StatusBarHeight;
        int inputH = 200;
        UIView *contentView = View.fixWH(250,inputH).bgColor(@"white").borderRadius(10);
        
        contentView.addTo(self).makeCons(^{
            make.centerX.equal.superview.End();
            make.top.equal.constants(normalH).End();
        });
        BeginIgnoreUIKVCAccessProhibited
        UITextView *textView = TextView.fnt(15).hint(@"输入您的反馈").color(@"#333");
        EndIgnoreUIKVCAccessProhibited
        textView.embedIn(contentView,20);
        
        self.fixWH(Screen.width,Screen.height).bgColor(@"0,0,0,0.1");
        
        WeakifySelf()
        [self setYRFeedbackInputStateBlock:^(BOOL showState) {
            if (showState) {
                weakSelf.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    contentView.qmui_top = normalH;
                } completion:^(BOOL finished) {
                    [textView becomeFirstResponder];
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    contentView.qmui_top = -inputH;
                } completion:^(BOOL finished) {
                    weakSelf.hidden = YES;
                }];
                [weakSelf endEditing:YES];
            }
        }];
        self.onClick(^{
            !self.YRFeedbackInputStateBlock?:self.YRFeedbackInputStateBlock(NO);
        });
        
        _textView = textView;
    }
    return self;
}
- (YRFeedbackPopColorView *)popChangeColorView{
    if (!_popChangeColorView) {
        _popChangeColorView = [[YRFeedbackPopColorView alloc] init];
        _popChangeColorView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionAbove;
        _popChangeColorView.automaticallyHidesWhenUserTap = YES;
    }
    return _popChangeColorView;
}
@end

@interface YRFeedbackViewController ()<QMUIModalPresentationContentViewControllerProtocol>
@property (strong, nonatomic) PaintView *paintView;
@property (strong, nonatomic) UIImageView *screenshotImageView;
@property (strong, nonatomic) YRFeedbackView *headerView;
@property (strong, nonatomic) YRFeedbackView *bottomView;
@property (strong, nonatomic) YRFeedbackView *inputView;
@end

@implementation YRFeedbackViewController
{
    UIImage *_screenshotImage;
}

- (instancetype)initWithScreenshotImage:(UIImage *)screenshotImage
{
    self = [super init];
    if (self) {
        _screenshotImage = screenshotImage;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenshotImageView.image = _screenshotImage;
    [self.paintView setScreenshotImage:_screenshotImage];
    [self configActions];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    !self.bottomView.YRFeedBackViewDidLayoutSubviewsBlock?:self.bottomView.YRFeedBackViewDidLayoutSubviewsBlock();
}

- (void)configActions{
    WeakifySelf()
    [self.headerView setNavActionBlock:^(YRFeedbackAction action) {
        [weakSelf handelAction:action];
    }];
    [self.bottomView setBottomActionBlock:^(YRFeedbackAction action) {
        [weakSelf handelAction:action];
    }];
    [self.paintView setPaintViewPaintingBlock:^(YRFeedBackPaintState state) {
        [weakSelf handelPaintActions:state];
    }];
    [self.bottomView.popChangeColorView setYRFeedbackChangeColorBlock:^(NSString *colorName) {
        [weakSelf.paintView changeColor:Color(colorName)];
        !weakSelf.bottomView.YRFeedbackChangeColorBlock?:weakSelf.bottomView.YRFeedbackChangeColorBlock(colorName);
    }];
}

- (void)handelPaintActions:(YRFeedBackPaintState) state{
    switch (state) {
        case YRFeedBackPaintStateBegin:
        case YRFeedBackPaintStateMove:{
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.alpha = 0;
            } completion:^(BOOL finished) {
            }];
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomView.alpha = 0;
            } completion:^(BOOL finished) {
            }];
            self.bottomView.hidden = YES;
            self.headerView.hidden = YES;
        }
            break;
        case YRFeedBackPaintStateCancel:
        case YRFeedBackPaintStateEnd:{
            self.headerView.hidden = NO;
            self.bottomView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.alpha = 1;
                self.bottomView.alpha = 1;
            }];
        }
            break;
        default:
            break;
    }
}
- (void)handelAction:(YRFeedbackAction)action{
    switch (action) {
        case YRFeedbackCancel:
             [[YRFeedbackActionManager sharedManager] dismissFeedbackView];
            break;
        case YRFeedbackSend:
            [self sendFeedBack];
            break;
        case YRFeedbackChangeColor:
            [self.bottomView.popChangeColorView showWithAnimated:YES];
            break;
        case YRFeedbackChangeEditText:
            self.inputView.YRFeedbackInputStateBlock(YES);
            break;
        case YRFeedbackChangeDelete:
            [self.paintView revoke];
            break;
        default:
            break;
    }
}

- (void)sendFeedBack{
    UIImage *image = [self.paintView convertViewToImage];
    NSString *content = self.inputView.textView.text;
    YRFeedbackModel *model = [YRFeedbackModel new];
    model.screenshot = image;
    model.content = content;
    [[YRFeedbackActionManager sharedManager] sendFeedBack:model];
    [[YRFeedbackActionManager sharedManager] dismissFeedbackView];
}


#pragma Set&Get
- (UIImageView *)screenshotImageView{
    if (!_screenshotImageView) {
        _screenshotImageView = [UIImageView new];
        _screenshotImageView.addTo(self.view).makeCons(^(){
            make.edge.equal.constants(0);
        });
    }
    return _screenshotImageView;
}
- (PaintView *)paintView{
    if (!_paintView) {
        _paintView = [[PaintView alloc] init];
        _paintView.addTo(self.view).makeCons(^(){
            make.edge.equal.constants(0);
        });
    }
    return _paintView;
}
- (YRFeedbackView *)headerView{
    if (!_headerView) {
        _headerView = [[YRFeedbackView alloc] initNavHeader];
        _headerView.addTo(self.view).makeCons(^{
            make.top.left.right.equal.constants(0);
        });
    }
    return _headerView;
}
- (YRFeedbackView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YRFeedbackView alloc] initBottomAction];
        _bottomView.addTo(self.view).makeCons(^{
            make.bottom.left.right.equal.constants(0);
        });
    }
    return _bottomView;
}
- (YRFeedbackView *)inputView{
    if (!_inputView) {
        _inputView = [[YRFeedbackView alloc] initInputView];
        _inputView.addTo(self.view).makeCons(^{
            make.edge.equal.constants(0);
        });
    }
    return _inputView;
}
@end
