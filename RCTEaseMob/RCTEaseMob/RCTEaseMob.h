//
//  RCTEaseMob.h
//  RCTEaseMob
//
//  Created by 5173 on 16/3/8.
//  Copyright © 2016年 William-Miao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "EaseMob.h"

@interface RCTEaseMob : NSObject <RCTBridgeModule, IChatManagerDelegate, EMCallManagerDelegate>

@end
