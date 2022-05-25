//
//  YBIBTopView.m
//  YBImageBrowserDemo
//
//  Created by 波儿菜 on 2019/7/6.
//  Copyright © 2019 杨波. All rights reserved.
//

#import "YBIBTopView.h"
#import "YBIBIconManager.h"
#import "YBIBUtilities.h"
#import "Masonry.h"
@interface YBIBTopView ()
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIButton *operationButton;
@end

@implementation YBIBTopView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pageLabel];
        [self addSubview:self.operationButton];
        
        [self setOperationType:YBIBTopViewOperationTypeMore];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height, width = self.bounds.size.width;
    //self.pageLabel.frame = CGRectMake(0, 0,self.bounds.size.width , height);
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
        make.width.offset(100);
    }];
    CGFloat buttonWidth = 54;
    self.operationButton.frame = CGRectMake(16, 0, buttonWidth, height);
}

#pragma mark - public

+ (CGFloat)defaultHeight {
    return 50;
}

- (void)setPage:(NSInteger)page totalPage:(NSInteger)totalPage {
    self.pageLabel.hidden  = NO;
    NSString *text = [NSString stringWithFormat:@"%ld/%ld", page + (NSInteger)1, totalPage];
    NSShadow *shadow = [NSShadow new];
    shadow.shadowBlurRadius = 4;
    shadow.shadowOffset = CGSizeMake(0, 1);
    shadow.shadowColor = UIColor.darkGrayColor;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSShadowAttributeName:shadow}];
    self.pageLabel.attributedText = attr;
}

#pragma mark - event

- (void)clickOperationButton:(UIButton *)button {
    if (self.clickOperation) self.clickOperation(self.operationType);
}
#pragma mark - getters & setters

- (void)setOperationType:(YBIBTopViewOperationType)operationType {
    _operationType = operationType;
    
    UIImage *image = nil;
    switch (operationType) {
        case YBIBTopViewOperationTypeSave:
            image = [YBIBIconManager sharedManager].toolSaveImage();
            break;
        case YBIBTopViewOperationTypeMore:
            image = [YBIBIconManager sharedManager].toolMoreImage();
            break;
    }
    
    [self.operationButton setImage:image forState:UIControlStateNormal];
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont boldSystemFontOfSize:16];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _pageLabel;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setImage:[UIImage imageNamed:@"signinorup_back"] forState:UIControlStateNormal];
        [_operationButton addTarget:self action:@selector(clickOperationButton:) forControlEvents:UIControlEventTouchUpInside];
//        _operationButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        _operationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//
//        _operationButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
//        _operationButton.layer.shadowOffset = CGSizeMake(0, 1);
//        _operationButton.layer.shadowOpacity = 1;
//        _operationButton.layer.shadowRadius = 4;
    }
    return _operationButton;
}

@end
