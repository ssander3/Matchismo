//
//  ViewController.m
//  Matchismo
//
//  Created by Melanie Sanders on 10/2/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchMode;
@property (weak, nonatomic) IBOutlet UITextField *history;
@end

@implementation ViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        _game.matchMode = self.matchMode.selectedSegmentIndex+1;
    }
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)redrawButton:(id)sender {
    // destroy the current game and update the UI
    self.game = nil;
    self.game.matchMode = self.matchMode.selectedSegmentIndex+1;
    [self updateUI];
}

- (IBAction)changeMatchMode:(UISegmentedControl *)sender
{
    self.game.matchMode = sender.selectedSegmentIndex+1;
}

- (void)updateUI
{
    // Update Match Mode
    self.matchMode.enabled = !self.game.isInGame;
    
    // Update Cards
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setTitleColor:[self colorForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    // Update Score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    
    // Update History text
    self.history.text = [[self.game matchHistory] lastObject];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (UIColor *)colorForCard:(Card *)card
{
    // if it is a heart or diamond set the color to red
    if ([[card contents] containsString:@"♦︎"] || [[card contents] containsString:@"♥︎"]) {
        return [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1];
    }
    else {
        // otherwise set the color to black
        return [UIColor colorWithWhite:0.0f alpha:1];
    }
}
@end
