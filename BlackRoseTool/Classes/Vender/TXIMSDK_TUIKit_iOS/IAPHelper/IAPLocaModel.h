//
//  IAPLocaModel.h
//  sa
//
//  Created by CocoLeo on 2020/3/27.
//  Copyright © 2020 sa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPLocaModel : NSObject

/** 产品id */
@property (nonatomic, copy) NSString *goodsId;
/** 订单号 */
@property (nonatomic, copy) NSString *orderNum;
/** 渠道IOS */
@property (nonatomic, copy) NSString *tempStr10th;
/** receipt */
@property (nonatomic, copy) NSString *tempStr9th;
/** reRequestInt */
@property (nonatomic, assign) NSInteger reRequestInt;

/// 历史记录重新请求提交
- (void)requestHistoryRecordMethod;

@end

NS_ASSUME_NONNULL_END
