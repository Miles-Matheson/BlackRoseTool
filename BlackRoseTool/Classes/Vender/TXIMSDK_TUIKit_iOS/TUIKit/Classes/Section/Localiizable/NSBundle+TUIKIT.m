//
//  NSBundle+TUIKIT.m
//  Pods
//
//  Created by harvy on 2020/10/9.
//

#import "NSBundle+TUIKIT.h"
#import "TUIKitConfig.h"

@implementation NSBundle (TUIKIT)

// tuikit 代码相关的国际化
+ (instancetype)tk_tuikitBundle
{
    static NSBundle *tuikitBundle = nil;
    if (tuikitBundle == nil) {
        tuikitBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[TUIKitConfig class]] pathForResource:@"TUIKitLocalizable" ofType:@"bundle"]];
    }
    return tuikitBundle;
}

+ (NSString *)tk_localizedStringForKey:(NSString *)key value:(nullable NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [self tk_localizableLanguageKey];
        
        // 从bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle tk_tuikitBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

+ (NSString *)tk_localizedStringForKey:(NSString *)key
{
    return [self tk_localizedStringForKey:key value:nil];
}

// tuikit 表情相关的国际化
+ (instancetype)tk_emojiBundle
{
    static NSBundle *emojiBundle = nil;
    if (emojiBundle == nil) {
        NSString *path = [[NSBundle bundleForClass:[TUIKitConfig class]] pathForResource:@"TUIKitFace" ofType:@"bundle"];
        emojiBundle = [NSBundle bundleWithPath:path];
    }
    return emojiBundle;
}

+ (NSString *)tk_emojiLocalizedStringForKey:(NSString *)key value:(nullable NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [self tk_localizableLanguageKey];
        language = [@"Localizable" stringByAppendingPathComponent:language];
        
        // 从bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle tk_emojiBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

+ (NSString *)tk_emojiLocalizedStringForKey:(NSString *)key
{
    return [self tk_emojiLocalizedStringForKey:key value:nil];
}

+ (NSString *)tk_localizableLanguageKey
{
    // 默认跟随系统
    // todo: 外部可配置
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        language = @"en";
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            language = @"zh-Hans"; // 简体中文
        } else { // zh-Hant\zh-HK\zh-TW
            language = @"zh-Hant"; // 繁體中文
        }
    } else if ([language hasPrefix:@"ko"]) {
        language = @"ko";
    } else if ([language hasPrefix:@"ru"]) {
        language = @"ru";
    } else if ([language hasPrefix:@"uk"]) {
        language = @"uk";
    } else {
        language = @"en";
    }
    return language;
}


@end


@implementation UIImage (Gradient)

- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(GradientType)gradientType {
    
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
//    NSUInteger capacity = percents.count;
//    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientFromTopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case GradientFromLeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case GradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case GradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation UIButton (Gradient)

- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type {
    
    UIImage *backImage = [[UIImage alloc]createImageWithSize:btnSize gradientColors:clrs percentage:percent gradientType:type];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    
    return self;
}

@end

@implementation UIButton (POImagePosition)

- (void)setImagePosition:(POImagePosition)postion withInset:(CGFloat)inset
{
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];
    
    CGFloat imageWidth  = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth  = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;
    CGFloat imageOffsetY = imageHeight / 2 + inset / 2;
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;
    CGFloat labelOffsetY = labelHeight / 2 + inset / 2;
    
    CGFloat tempWidth     = MAX(labelWidth, imageWidth);
    CGFloat changedWidth  = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight    = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + inset - tempHeight;
    
    switch (postion) {
        case POImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -inset/2, 0, inset/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, inset/2, 0, -inset/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, inset/2, 0, inset/2);
            break;
        case POImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + inset/2, 0, -(labelWidth + inset/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + inset/2), 0, imageWidth + inset/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, inset/2, 0, inset/2);
            break;
        case POImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
        case POImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
        default:
            break;
    }
}

@end
