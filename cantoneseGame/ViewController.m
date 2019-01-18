//
//  ViewController.m
//  cantoneseGame
//
//  Created by dw on 16/1/1.
//  Copyright © 2016年 slippers. All rights reserved.
//

#import "ViewController.h"
#import "GDWalkThrghView.h"
#import "config.h"

static NSString * const sampleDestOne = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque tincidunt laoreet diam, id suscipit ipsum sagittis a. ";



static NSString * const sampleDestTwo = @" Suspendisse et ultricies sem. Morbi libero dolor, dictum eget aliquam quis, blandit accumsan neque. Vivamus lacus justo, viverra non dolor nec, lobortis luctus risus.";

static NSString * const sampleDestThree = @"In interdum scelerisque sem a convallis. Quisque vehicula a mi eu egestas. Nam semper sagittis augue, in convallis metus";

static NSString * const sampleDestFour = @"Praesent ornare consectetur elit, in fringilla ipsum blandit sed. Nam elementum, sem sit amet convallis dictum, risus metus faucibus augue, nec consectetur tortor mauris ac purus.";

static NSString * const sampleDestFive = @"Sed rhoncus arcu nisl, in ultrices mi egestas eget. Etiam facilisis turpis eget ipsum tempus, nec ultricies dui sagittis. Quisque interdum ipsum vitae ante laoreet, id egestas ligula auctor";

@interface ViewController ()<GDWalkThrghViewDataSource>
@property (nonatomic, strong) GDWalkThrghView* walkhView ;
@property(nonatomic,strong) GDWalkThrgPageCell *walkhCell;

@property (nonatomic, strong) NSArray* descStrsArr;

@property (nonatomic, strong) UILabel* welcomeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //加入GHWalkThrough 作为选关系统
    _walkhView = [[GDWalkThrghView alloc] initWithFrame:self.view.bounds];
    [_walkhView setDataSource:self];
    [_walkhView setWalkThrghDirection:GDWalkThrghViewDirectionVertical];
    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/15)];
    welcomeLabel.text = @"Welcome";
    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:kScreenHeight/15];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel = welcomeLabel;
    
    NSString *tip1= NSLocalizedString(@"tip1",@"");
    NSString *tip2= NSLocalizedString(@"tip2",@"");
    NSString *tip3= NSLocalizedString(@"tip3",@"");
    NSString *tip4= NSLocalizedString(@"tip4",@"");
    NSString *tip5= NSLocalizedString(@"tip5",@"");
    
    self.descStrsArr = [NSArray arrayWithObjects:tip1,tip2, tip3, tip4, tip5, nil];
    
    
    
    [_walkhView setVFltingHeader:self.welcomeLabel];
    // self.ghView.isfixedBackground = YES;
    [self.walkhView setWalkThrghDirection:GDWalkThrghViewDirectionHorizontal];
    //转到当前的选择cell上
    
    int theResenceCell=(int)[[NSUserDefaults standardUserDefaults]integerForKey:presenceCell];
    
    [self.walkhView showInfortionView:self.view animateDuration:0.3];
    [UIView animateWithDuration:0.0 delay:0.0 options:0 animations:^{
        [self.walkhView.cletionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:theResenceCell inSection:0]
                                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                   animated:NO];
    } completion:^(BOOL finished) {
        NSLog(@"Completed");
    }];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 5;
}

- (void) configrationPage:(GDWalkThrgPageCell *)cell atIndex:(NSInteger)index
{
    cell.tilStr = [NSString stringWithFormat:@"Tip %ld", index+1];
    cell.imgTitle = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld", index+1]];
    cell.descrity = [self.descStrsArr objectAtIndex:index];
    
    cell.butnTag=index*9;
}

- (UIImage*) backgdImageforPage:(NSInteger)index
{
    NSString* imgName =[NSString stringWithFormat:@"bg_0%ld.jpg", index+1];
    UIImage* imges = [UIImage imageNamed:imgName];
    return imges;
}


@end
