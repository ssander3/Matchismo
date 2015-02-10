//
//  GameResult.m
//  Matchismo
//
//  Created by Scott Sanders on 2/1/15.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()

@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;

@end


@implementation GameResult

#define ALL_RESULTS_KEY @"GameResults_All"
#define START_KEY @"StartDate"
#define END_Key @"EndDate"
#define SCORE_KEY @"Score"
#define GAME_KEY @"Game"

- (NSTimeInterval) duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

- (id)init
{
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (id)initFromPropertyList:(id)pList
{
    self = [self init];
    if (self) {
        if ([pList isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultsDictionary =  (NSDictionary *)pList;
            _start = resultsDictionary[START_KEY];
            _end = resultsDictionary[END_Key];
            _score = [resultsDictionary[SCORE_KEY] intValue];
            _gameType = resultsDictionary[GAME_KEY];
            if (!_start || !_end) {
                self = nil;
            }
        }
    }
    return self;
}

- (id) asPropertyList
{
    return @{ START_KEY : self.start, END_Key : self.end, SCORE_KEY : @(self.score), GAME_KEY : self.gameType};
}

- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) {
        mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    }
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues    ]) {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    return allGameResults;
}

- (NSComparisonResult)compareDuration:(GameResult *)result
{
    return [@(self.duration) compare:@(result.duration)];
}

- (NSComparisonResult)compareScore:(GameResult *)result
{
    return [@(self.score) compare:@(result.score)];
    
}

- (NSComparisonResult)compareDate:(GameResult *)result
{
    return [self.end compare:result.end];
}

@end
