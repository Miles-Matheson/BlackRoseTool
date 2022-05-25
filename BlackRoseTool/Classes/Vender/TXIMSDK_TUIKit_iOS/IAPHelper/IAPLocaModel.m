//
//  IAPLocaModel.m
//  sa
//
//  Created by CocoLeo on 2020/3/27.
//  Copyright © 2020 sa. All rights reserved.
//

#import "IAPLocaModel.h"

@implementation IAPLocaModel

- (NSString *)tempStr10th {
    return @"IOS";
}

- (void)requestHistoryRecordMethod {
    
//    IAPLocaModel *model = [IAPLocaModel mj_objectWithKeyValues:[NeighborsSimpleCuteUserModel locaOrderInfo]];
//    if (model && model.reRequestInt > 0) {
//        
//        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[model mj_JSONObject]];
//        param[@"appType"]   = @"88";
//        param[@"clientNum"] = @"88001002";
//        NSString *baseUrl  = [NSString stringWithFormat:@"%@%@",NSC_Base_Url,@"api/user/addOrderRecord"];
//        __weak typeof(self) weakSelf = self;
//        [[NeighborsSimpleCuteNetworkTool sharedNetworkTool] POST:baseUrl parameters:param success:^(NeighborsSimpleCuteResposeModel * _Nonnull response) {
//            model.reRequestInt -= 1;
//            [NeighborsSimpleCuteUserModel setLocaOrderInfo:[model mj_JSONObject]];
//            if (model.reRequestInt > 0) {
//                [weakSelf requestHistoryRecordMethod];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            
//        }];
//    }
}
@end
