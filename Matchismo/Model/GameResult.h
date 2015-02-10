//
//  GameResult.h
//  Matchismo
//
//  Created by Scott Sanders on 2/1/15.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *) allGameResults;
@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSString *gameType;

- (NSComparisonResult)compareScore:(GameResult *)result;
- (NSComparisonResult)compareDuration:(GameResult *)result;
- (NSComparisonResult)compareDate:(GameResult *)result;

@end
