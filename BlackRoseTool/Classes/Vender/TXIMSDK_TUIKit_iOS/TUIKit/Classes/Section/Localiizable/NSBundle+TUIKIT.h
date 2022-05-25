//
//  NSBundle+TUIKIT.h
//  Pods
//
//  Created by harvy on 2020/10/9.
//

#import <Foundation/Foundation.h>
#import "THeader.h"

NS_ASSUME_NONNULL_BEGIN

#define TUILocalizableString(key) [NSBundle tk_localizedStringForKey:@""#key""]
#define TUIEmojiLocalizableString(key) [NSBundle tk_emojiLocalizedStringForKey:@""#key""]

@interface NSBundle (TUIKIT)

#pragma mark - TUIKit 代码相关国际化
+ (NSString *)tk_localizedStringForKey:(NSString *)key value:(nullable NSString *)value;
+ (NSString *)tk_localizedStringForKey:(NSString *)key;


#pragma mark - TUIKit 内置表情相关国际化
+ (NSString *)tk_emojiLocalizedStringForKey:(NSString *)key value:(nullable NSString *)value;
+ (NSString *)tk_emojiLocalizedStringForKey:(NSString *)key;

+ (NSString *)tk_localizableLanguageKey;

@end

typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,            //从上到下
    GradientFromLeftToRight,                //从做到右
    GradientFromLeftTopToRightBottom,       //从上到下
    GradientFromLeftBottomToRightTop        //从上到下
};

@interface UIImage (Gradient)

/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param percents          渐变颜色的占比数组
 *  @param gradientType     渐变色的类型
 */
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr percentage:(NSArray *)percents gradientType:(GradientType)gradientType;

@end


@interface UIButton (Gradient)

/**
 *  根据给定的颜色，设置按钮的颜色
 *  @param btnSize  这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
 *  @param clrs     渐变颜色的数组
 *  @param percent  渐变颜色的占比数组
 *  @param type     渐变色的类型
 */
- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type;

@end


typedef NS_ENUM(NSInteger, POImagePosition) {
    POImagePositionLeft   = 0,
    POImagePositionRight  = 1,
    POImagePositionTop    = 2,
    POImagePositionBottom = 3,
};

@interface UIButton (POImagePosition)

- (void)setImagePosition:(POImagePosition)postion withInset:(CGFloat)inset;

@end

NS_ASSUME_NONNULL_END
