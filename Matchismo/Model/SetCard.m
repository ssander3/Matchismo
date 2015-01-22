//
//  SetCard.m
//  Matchismo
//
//  Created by Scott Sanders on 12/28/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#pragma mark - properties

@synthesize symbol = _symbol;
@synthesize shade = _shade;
@synthesize color = _color;

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)shade
{
    return _shade ? _shade : @"?";
}

- (void)setShade:(NSString *)shade
{
    if ([[SetCard validShades] containsObject:shade]) {
        _shade = shade;
    }
}

- (NSString *)color
{
    return _color ? _color : @"?";
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

#pragma mark - class methods

+ (NSArray *)validSymbols
{
    return @[@"oval", @"squiggle", @"diamond"];
}

+ (NSArray *)validShades
{
    return @[@"open", @"striped", @"solid"];
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"blue"];
}

+ (NSUInteger)maxNumber
{
    return 3;
}

#pragma mark - match

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == self.numberOfMatchingCards - 1)
    {
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSMutableArray *shades = [[NSMutableArray alloc] init];
        NSMutableArray *symbols = [[NSMutableArray alloc] init];
        NSMutableArray *numbers = [[NSMutableArray alloc] init];
        [colors addObject:self.color];
        [shades addObject:self.shade];
        [symbols addObject:self.symbol];
        [numbers addObject:@(self.number)];
        for (id otherCard in otherCards) {
            if ([otherCard isKindOfClass:[SetCard class]]) {
                SetCard *otherSetCard = (SetCard *)otherCard;
                
                //if this color is not in the array already, add it
                if (![colors containsObject:otherSetCard.color]) {
                    [colors addObject:otherSetCard.color];
                }
                //if this shade is not in the array already, add it
                if (![shades containsObject:otherSetCard.shade]) {
                    [shades addObject:otherSetCard.shade];
                }
                //if this symbol is not in the array already, add it
                if (![symbols containsObject:otherSetCard.symbol]) {
                    [symbols addObject:otherSetCard.symbol];
                }
                //if this number is not in the array already, add it
                if (![numbers containsObject:@(otherSetCard.number)]) {
                    [numbers addObject:@(otherSetCard.number)];
                }
                
                //score a match
                if (([colors count] == 1 || [colors count] == self.numberOfMatchingCards)
                    && ([shades count] == 1 || [shades count] == self.numberOfMatchingCards)
                    && ([symbols count] == 1 || [symbols count] == self.numberOfMatchingCards)
                    && ([numbers count] == 1 || [numbers count] == self.numberOfMatchingCards)) {
                    score = 4;
                }
            }
        }
    }
    
    return score;
}

-(NSString *)contents
{
    return [NSString stringWithFormat:@"%@:%@:%@:%lu", self.symbol, self.color ,self.shade, (unsigned long)self.number];
}

- (id) init
{
    self = [super init];
    
    if (self) {
        self.numberOfMatchingCards = 3;
    }
    
    return self;
}

@end
