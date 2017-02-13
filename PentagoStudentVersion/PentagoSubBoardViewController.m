//
//  PentagoSubBoardViewController.m
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//
//  Modified by Joji Kubota & Jeffrey Teller on 9/24/14.
//

#import "PentagoSubBoardViewController.h"
#import "PentagoBrain.h"
#import "PentagoViewController.h"

const int BORDER_WIDTH = 10; // Side margin.
const int TOP_MARGIN = 50;

// Added stuff
typedef enum  : NSInteger {player1 = 1, player2 = 2} Player; // To switch between two players.

@interface PentagoSubBoardViewController () {
    int subsquareNumber; // ID for the subsquare.
    int widthOfSubsquare;
    
    Player player; // To hold who's turn.
    NSString *whichMarble; // Red vs green.
}

@property(nonatomic, strong) PentagoBrain *pBrain;
@property(nonatomic, strong) UIImageView *gridImageView; // for grid image.
@property(nonatomic, strong) UITapGestureRecognizer *tapGest;
@property(nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;
@property(nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;
@property(nonatomic, strong) UIView *gridView; // view in front
@property(nonatomic, strong) CALayer *ballLayer; // for marble image.
@property(nonatomic, strong) UIView *backView; // view without animation.
@property(nonatomic, strong) NSMutableArray *balls;

@property(nonatomic, strong) PentagoViewController *viewAccess;

@end

@implementation PentagoSubBoardViewController

-(UITapGestureRecognizer *) tapGest
{
    if( ! _tapGest ) {
        _tapGest = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(didTapTheView:)];
        
        [_tapGest setNumberOfTapsRequired:1];
        [_tapGest setNumberOfTouchesRequired:1];
    }
    return _tapGest;
}

-(UISwipeGestureRecognizer *) rightSwipe
{
    if( !_rightSwipe ) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return _rightSwipe;
}

-(UISwipeGestureRecognizer *) leftSwipe
{
    if (!_leftSwipe) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    return _leftSwipe;
}

-(PentagoBrain *) pBrain
{
    if( ! _pBrain )
    {
        _pBrain = [PentagoBrain sharedInstance];
    }
    return _pBrain;
}

-(UIImageView *) gridImageView
{
    if( ! _gridImageView ) {
        _gridImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    }
    return _gridImageView;
}

-(id) initWithSubsquare: (int) position : (PentagoViewController*) pPtr
{
    // 0 1
    // 2 3
    if( (self = [super init]) == nil )
        return nil;
    self.viewAccess = pPtr; // pointer to PentagoViewCotroller.
    subsquareNumber = position;
    // appFrame is the frame of the entire screen so that appFrame.size.width
    // and appFrame.size.height contain the width and the height of the screen, respectively.
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    widthOfSubsquare = ( appFrame.size.width - 3 * BORDER_WIDTH ) / 2;
    return self;
}


-(void) didTapTheView: (UITapGestureRecognizer *) tapObject
{
    // check for draw game.
    if ([self.pBrain checkDraw])
        [self.viewAccess announceWinner: 3];
    
    // Check if the player is allowed to place a marble.
    if (![self.pBrain isGameStarted] ||
        ![self.pBrain findCanPlaceMarbleStatus])
        return;
    
    // p is the location of the tap in the coordinate system of this view-controller's view (not the view of the
    // the view-controller that includes the subboards.)
    CGPoint p = [tapObject locationInView:self.backView];
    NSLog(@"tapped at: %@", NSStringFromCGPoint(p) );
    int squareWidth = widthOfSubsquare / 3;
    
    // Decide whose turn it is.
    player = [self.pBrain whoseTurn];
    
    // Set the correct color marble
    if (player == player1) {
        whichMarble = @"redMarble.png";
    }
    else {
        whichMarble = @"greenMarble.png";
    }
    
    // Check if potential move is not taken before placing marble.
    if ([self.pBrain isLegalMove:p.x / squareWidth :p.y / squareWidth :subsquareNumber])
    {
        // Add the new move to the pBrain.
        [self.pBrain addMove:p.x / squareWidth :p.y / squareWidth :subsquareNumber];
        
        // The board is divided into nine equally sized squares and thus width = height.
        UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:whichMarble]];
        iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth + 2,
                                 (int) (p.y / squareWidth) * squareWidth + 2,
                                 squareWidth - BORDER_WIDTH / 3,
                                 squareWidth - BORDER_WIDTH / 3);
        self.ballLayer = [CALayer layer];
        [self.ballLayer addSublayer: iView.layer];
        self.ballLayer.frame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
        if ([self.balls count] > 0)
            self.ballLayer.affineTransform = ((UIImageView *) self.balls[0]).layer.affineTransform;
        else
            self.ballLayer.affineTransform =
            CGAffineTransformIdentity;
        
        // check for winner;
        NSLog(@"Winner is: %ld", (long)[self.pBrain checkWinner]);
        if ([self.pBrain checkWinner] != 0)
            [self.viewAccess announceWinner: [self.pBrain checkWinner]];
        
        // Swtich the player.
        [self.pBrain flipPlayerTurn];
        
        // if board is not neutral, current player must rotate a sub-board
        // before next player can place a marble.
        if (! [self.pBrain isNutural])
            [self.pBrain setCanPlaceMarbleStatus: NO]; // swtich to NO.
        
        // Player may rotate after placing a marble.
        [self.pBrain setCanRotate: YES]; // swtich to YES.
        
        [self.gridView.layer addSublayer:self.ballLayer];
        [self.balls addObject:iView];
    }

}

-(void) didSwipeRight: (UISwipeGestureRecognizer *) swipeObject
{

    if( ![self.pBrain shouldRotate: subsquareNumber] )
        return;
    CGAffineTransform currTransform = self.gridView.layer.affineTransform;
    [UIView animateWithDuration:.5 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI/2));
        self.gridView.layer.affineTransform = newTransform;
        [UIView animateWithDuration:.5 animations:^{
            for( UIImageView *iView in self.balls )
                iView.layer.affineTransform = CGAffineTransformConcat(iView.layer.affineTransform,
                                                                      CGAffineTransformMakeRotation(-M_PI/2));
        } completion:^(BOOL finished) {
            
        }];
    }];
    // Reflect the new status in pBrain.
    [self.pBrain rightRotation:subsquareNumber];
    
    // check for winner;
    if ([self.pBrain checkWinner] != 0)
        [self.viewAccess announceWinner: [self.pBrain checkWinner]];
    
    // check for draw game.
    if ([self.pBrain checkDraw])
        [self.viewAccess announceWinner: 3];
    
    // next player can place a marble after the rotation.
    [self.pBrain setCanPlaceMarbleStatus: YES];
    
    // board cannot be rotated again until a marble is placed.
    [self.pBrain setCanRotate: NO];
    
    [self.view bringSubviewToFront:self.gridView];
    [self.view addGestureRecognizer:self.rightSwipe];
}

-(void) didSwipeLeft:(UISwipeGestureRecognizer *) swipeObject
{
    if ( ![self.pBrain shouldRotate: subsquareNumber])
        return;
    CGAffineTransform currTransform = self.gridView.layer.affineTransform;
    [UIView animateWithDuration:.5 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(-M_PI/2));
        self.gridView.layer.affineTransform = newTransform;
        [UIView animateWithDuration:.5 animations:^{
            for (UIImageView *iView in self.balls)
                iView.layer.affineTransform = CGAffineTransformConcat(iView.layer.affineTransform, CGAffineTransformMakeRotation(M_PI/2));
        } completion:^(BOOL finished) {
            
        }];
    }];
    // Reflect the new status in pBrain.
    [self.pBrain leftRotation:subsquareNumber];
    
    // check for winner;
    if ([self.pBrain checkWinner] != 0)
        [self.viewAccess announceWinner: [self.pBrain checkWinner]];
    
    // check for draw game.
    if ([self.pBrain checkDraw])
        [self.viewAccess announceWinner: 3];
     
    // next player can place a marble after the rotate.
    [self.pBrain setCanPlaceMarbleStatus: YES];
    
    // board cannot be rotated again until a marble is placed.
    [self.pBrain setCanRotate: NO];
    
    [self.view bringSubviewToFront:self.gridView];
    [self.view addGestureRecognizer:self.leftSwipe];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize pBrain.
    self.pBrain = [PentagoBrain sharedInstance];
    [self.pBrain startGame];
    
    CGRect ivFrame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    
    // Initialize the views.
    self.backView = [[UIView alloc] initWithFrame:ivFrame];
    self.gridView = [[UIView alloc] initWithFrame:ivFrame];
    [self.backView addSubview:self.gridView];
    
    // setup gesture recognizer.
    [self.view addGestureRecognizer:self.rightSwipe];
    [self.view addGestureRecognizer:self.leftSwipe];
    [self.gridView addGestureRecognizer: self.tapGest];
    
    // grid image
    self.gridImageView.frame = ivFrame;
    UIImage *image = [UIImage imageNamed:@"grid.png"];
    [self.gridImageView setImage:image];
    [self.gridView addSubview:self.gridImageView];
    [self.gridView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.backView];
    self.balls = [[NSMutableArray alloc] init];
    
    CGRect viewFrame = CGRectMake( (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber % 2) + BORDER_WIDTH,
                                  (BORDER_WIDTH + widthOfSubsquare) * (subsquareNumber / 2) + BORDER_WIDTH + TOP_MARGIN,
                                  widthOfSubsquare, widthOfSubsquare);
    self.view.frame = viewFrame;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
