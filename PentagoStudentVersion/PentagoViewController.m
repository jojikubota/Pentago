//
//  PentagoViewController.m
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//
//  Modified by Joji Kubota & Jeffrey Teller on 9/24/14.
//

#import "PentagoViewController.h"
#import "PentagoSubBoardViewController.h"



@interface PentagoViewController () {
    NSString * label;
}
@property (nonatomic, strong) NSMutableArray *subViewControllers;



@end

@implementation PentagoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *) subViewControllers
{
    if( ! _subViewControllers )
        _subViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    return _subViewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    [self.view setFrame:frame];
    
    // This is our root view-controller. Each of the quadrants of the game is
    // represented by a different view-controller. We create them here and add their views to the
    // view of the root view-controller.
    for (int i = 0; i < 4; i++) {
        PentagoSubBoardViewController *p = [[PentagoSubBoardViewController alloc] initWithSubsquare:i :self];
        [p.view setBackgroundColor:[UIColor blackColor]];
        [self.subViewControllers addObject: p];
        [self.view addSubview: p.view];
    }
    
    // winner label.
    label = @"winner player 1";
    self.iLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.iLabel.text = label;
    CGRect lFrame = [[UIScreen mainScreen] applicationFrame];

    self.iLabel.textColor = [UIColor whiteColor];
    [self.iLabel sizeToFit];
    self.iLabel.center = CGPointMake(lFrame.size.width / 2.0,
                                400);
    [self.view addSubview:self.iLabel];
    [self.iLabel setAlpha:0];
}

-(void) announceWinner: (NSInteger) winner
{

    if (winner == 1)
        label = @"Player 1 Wins!";
    else if (winner == 2)
        label = @"Player 2 Wins!";
    else if (winner == 3)
        label = @"Draw Game!";
    else
        label = @"";
    self.iLabel.text = label;
    [self.iLabel setAlpha:1];
    [self.view bringSubviewToFront:self.iLabel];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
