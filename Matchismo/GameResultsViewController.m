//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by Scott Sanders on 2/1/15.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResult.h"

@interface GameResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *gameResultsTextView;
@property (strong, nonatomic) NSArray * gameResults;
@end

@implementation GameResultsViewController

#pragma mark - UI Update
- (void)updateUI
{
    NSString *text = @"";
    for (GameResult *result in self.gameResults) {
        text = [text stringByAppendingString:[self stringFromResult:result]];
    }
    self.gameResultsTextView.text = text;
    
    NSArray *sortedResults = [self.gameResults sortedArrayUsingSelector:@selector(compareScore:)];
    [self changeResult:[sortedResults firstObject] toColor:[UIColor redColor]];
    [self changeResult:[sortedResults lastObject] toColor:[UIColor greenColor]];
    sortedResults = [self.gameResults sortedArrayUsingSelector:@selector(compareDuration:)];
    [self changeResult:[sortedResults firstObject] toColor:[UIColor purpleColor]];
    [self changeResult:[sortedResults lastObject] toColor:[UIColor blueColor]];
}

- (NSString *)stringFromResult:(GameResult *)result
{
    return [NSString stringWithFormat:@"%@: %ld, (%@, %gs)\n",
            result.gameType,
            (long)result.score,
            [NSDateFormatter localizedStringFromDate:result.end dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle],
            round(result.duration)];
}

- (void)changeResult:(GameResult *)result toColor:(UIColor *)color
{
    NSRange range = [self.gameResultsTextView.text rangeOfString:[self stringFromResult:result]];
    [self.gameResultsTextView.textStorage addAttribute:NSForegroundColorAttributeName value:color range:range];
}

#pragma mark - View Class Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.gameResults = [GameResult allGameResults];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
