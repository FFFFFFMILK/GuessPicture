//
//  OptionModel.m
//  GuessPicture
//
//  Created by Fu on 2017/7/21.
//  Copyright © 2017年 Fu. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

+(instancetype)optionModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
