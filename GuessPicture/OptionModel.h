//
//  OptionModel.h
//  GuessPicture
//
//  Created by Fu on 2017/7/21.
//  Copyright © 2017年 Fu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *options;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)optionModelWithDict:(NSDictionary *)dict;

@end
