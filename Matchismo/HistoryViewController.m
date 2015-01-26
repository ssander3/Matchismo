//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Scott Sanders on 1/23/15.
//  Copyright (c) 2015 CS193p. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

- (void)setHistory:(NSArray *)history
{
    _history = history;
    if (self.view.window) [self updateUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    if ([[self.history firstObject] isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *histroyText = [[NSMutableAttributedString alloc] init];
        int i = 1;
        for (NSAttributedString *line in self.history) {
            [histroyText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%2d: ", i++]]];
            [histroyText appendAttributedString:line];
            [histroyText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        }
        UIFont *font = [self.historyTextView.textStorage attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        [histroyText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, histroyText.length)];
        self.historyTextView.attributedText = histroyText;
    }
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
