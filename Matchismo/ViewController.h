//
//  ViewController.h
//  Matchismo
//
//  Created by Melanie Sanders on 10/2/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//
// Abstract class. Must implement methods as described below

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface ViewController : UIViewController

// protected
// for subclasses
- (Deck *)createDeck;    // abstract

- (NSAttributedString *)titleForCard:(Card *)card;
- (NSAttributedString *)attributedContentsOfCard:(Card *)card;
- (UIImage *)backgroundImageForCard:(Card *)card;
- (void)updateUI;

@property (strong, nonatomic) NSString *gameType;

@end

