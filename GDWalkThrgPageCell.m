//
//  GHWalkThroughCell.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "GDWalkThrgPageCell.h"
//#import "ViewController.h"
#import "AppDelegate.h"
#import "config.h"


@interface GDWalkThrgPageCell ()

@property (nonatomic, strong) UILabel* lbTitle;
@property (nonatomic, strong) UITextView* tvDescor;
@property (nonatomic, strong) UIImageView* titleImgVw;
@property (nonatomic,assign) int thorMaIndx;


@end

@implementation GDWalkThrgPageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self appliedDefaults];
        [self buildringUIter];
       self.thorMaIndx=(int)[[NSUserDefaults standardUserDefaults]integerForKey:maxIndex];
    }
    return self;
}

#pragma mark setters

- (void)setTilStr:(NSString *)tilStr{
    _tilStr = tilStr;
    self.lbTitle.text = self.tilStr;
    self.lbTitle.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenHeight/45 ];
    [self setNeedsLayout];
}

- (void)setImgTitle:(UIImage *)imgTitle{
    _imgTitle = imgTitle;
    self.titleImgVw.image = self.imgTitle;
	self.titleImgVw.contentMode = UIViewContentModeScaleAspectFit;
    [self setNeedsLayout];
}

- (void)setDescrity:(NSString *)descrity{
    _descrity = descrity;
    self.tvDescor.text = self.descrity;
    self.tvDescor.font=[UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenHeight/50 ];
    [self setNeedsLayout];
}

- (void)setButnTag:(NSInteger)butnTag{

   _butnTag = butnTag;
        [self buildorenBttn];

    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect1 = self.titleImgVw.frame;
    rect1.origin.x = (self.contentView.frame.size.width - rect1.size.width)/2;
    rect1.origin.y = self.bounds.size.height - self.titlPositnY - self.imgPositedY - rect1.size.height;
    self.titleImgVw.frame = rect1;

    [self layoutTitlorLb];
    
    CGRect descLlFrm = CGRectMake(20, self.bounds.size.height - self.desPositnY, self.contentView.frame.size.width - 40, 500);
    self.tvDescor.frame = descLlFrm;
    
}

- (void) layoutTitlorLb
{
    CGFloat titlHegt;
    
    if ([self.tilStr respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSAttributedString *attribTxtStr = [[NSAttributedString alloc] initWithString:self.tilStr attributes:@{ NSFontAttributeName: self.tileFt }];
        CGRect rectOnr = [attribTxtStr boundingRectWithSize:(CGSize){self.contentView.frame.size.width - 20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        titlHegt = ceilf(rectOnr.size.height);
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        titlHegt = [self.tilStr sizeWithFont:self.tileFt constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
#pragma clang diagnostic pop
    }
    
    CGRect titleLbFrm = CGRectMake(10, self.bounds.size.height - self.titlPositnY, self.contentView.frame.size.width - 20, titlHegt);

    self.lbTitle.frame = titleLbFrm;
}

- (void) appliedDefaults
{
    self.tilStr = @"Title";
    self.descrity = @"Default Description";
    
    self.imgPositedY    = 50.0f;
    self.titlPositnY  = 180.0f;
    self.desPositnY   = 160.0f;
    self.tileFt = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    self.titlClur = [UIColor whiteColor];
    self.desoryFont = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.desClur = [UIColor whiteColor];
}

- (void) buildringUIter {
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *vPage = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    if (self.titleImgVw == nil) {
        UIImageView *imgTitle = self.imgTitle != nil ? [[UIImageView alloc] initWithImage:self.imgTitle] : [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4*3, kScreenWidth/4*3)];
        self.titleImgVw = imgTitle;
    }
    [vPage addSubview:self.titleImgVw];
    
    if(self.lbTitle == nil) {
        UILabel *titleLl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLl.text = self.tilStr;
        titleLl.font = self.tileFt;
        titleLl.textColor = self.titlClur;
        titleLl.backgroundColor = [UIColor clearColor];
        titleLl.textAlignment = NSTextAlignmentCenter;
        titleLl.lineBreakMode = NSLineBreakByWordWrapping;
        [vPage addSubview:titleLl];
        self.lbTitle = titleLl;
    }
    
    if(self.tvDescor == nil) {
        UITextView *descLbl = [[UITextView alloc] initWithFrame:CGRectZero];
        descLbl.text = self.descrity;
        descLbl.scrollEnabled = NO;
        descLbl.font = self.desoryFont;
        descLbl.textColor = self.desClur;
        descLbl.backgroundColor = [UIColor clearColor];
        descLbl.textAlignment = NSTextAlignmentCenter;
        descLbl.userInteractionEnabled = NO;
        [vPage addSubview:descLbl];
        self.tvDescor = descLbl;
    }

    [self.contentView addSubview:vPage];
}

-(void)buildorenBttn{
    
    UIImage *unlocked = [UIImage imageNamed:@"unlock.png"];
    UIImage *locked = [UIImage imageNamed:@"lock.png"];
    
    CGRect scrnRect = [[UIScreen mainScreen] bounds];
    
    int bordry = scrnRect.size.width / 4*1; // 30 percent outside border: edge to center of outside tile
    int totalBodry = bordry * 2;
    int useabArea = scrnRect.size.width - totalBodry;
    int columnors = 3;
    int spansory = columnors - 1;
    int spander = useabArea / spansory;
    int startPoint = bordry;
    
    // Row 1
    for (int i = 0; i < columnors; i++){

        UIButton *buttnOne = [UIButton buttonWithType:UIButtonTypeCustom];
        buttnOne.frame=CGRectMake(10, 10, kScreenWidth/5, kScreenWidth/5);
        buttnOne.center=CGPointMake(startPoint, scrnRect.size.height/10 * 3.5);
        buttnOne.backgroundColor=[UIColor clearColor];
        buttnOne.tag=self.butnTag+i;
        buttnOne.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/8 ];
        [buttnOne addTarget:self action:@selector(buttnActionion:) forControlEvents:UIControlEventTouchUpInside];
        NSString *bttn1Title =[NSString stringWithFormat: @"%ld", (long)self.butnTag+i];
        
        if (buttnOne.tag<=self.thorMaIndx) {
            [buttnOne setBackgroundImage:unlocked forState:UIControlStateNormal ];
            [buttnOne setTitle:bttn1Title forState:UIControlStateNormal];
        }else{
            [buttnOne setBackgroundImage:locked forState:UIControlStateNormal ];
        }

        [self.contentView addSubview:buttnOne];
        
        startPoint += spander;
    }
    
    startPoint = bordry;
    
    // Row 2
    for (int i = 0; i < columnors; i++){
        
        UIButton *bttnOne = [UIButton buttonWithType:UIButtonTypeCustom];
        bttnOne.frame=CGRectMake(10, 10, kScreenWidth/5, kScreenWidth/5);
        bttnOne.center=CGPointMake(startPoint, scrnRect.size.height/10 * 5);
        bttnOne.backgroundColor=[UIColor clearColor];
        bttnOne.tag=self.butnTag+i+3;
        bttnOne.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/8 ];
        [bttnOne addTarget:self action:@selector(buttnActionion:) forControlEvents:UIControlEventTouchUpInside];
        NSString *butn1Title =[NSString stringWithFormat: @"%ld", (long)self.butnTag+i+3];
        
        if (bttnOne.tag<=self.thorMaIndx) {
            [bttnOne setBackgroundImage:unlocked forState:UIControlStateNormal ];
            [bttnOne setTitle:butn1Title forState:UIControlStateNormal];
        }else{
            [bttnOne setBackgroundImage:locked forState:UIControlStateNormal ];
        }

        [self.contentView addSubview:bttnOne];
        
        startPoint += spander;
    }
    
    startPoint = bordry;
    
    // Row 3
    for (int i = 0; i < columnors; i++){

        UIButton *buttOne = [UIButton buttonWithType:UIButtonTypeCustom];
        buttOne.frame=CGRectMake(10, 10, kScreenWidth/5, kScreenWidth/5);
        buttOne.center=CGPointMake(startPoint, scrnRect.size.height/10 * 6.5);
        buttOne.backgroundColor=[UIColor clearColor];
        buttOne.tag=self.butnTag+i+6;
        buttOne.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:kScreenWidth/8 ];
        [buttOne addTarget:self action:@selector(buttnActionion:) forControlEvents:UIControlEventTouchUpInside];
        NSString *buttOneTitle =[NSString stringWithFormat: @"%ld", (long)self.butnTag+i+6];
        if (buttOne.tag<=self.thorMaIndx) {
            [buttOne setBackgroundImage:unlocked forState:UIControlStateNormal ];
            [buttOne setTitle:buttOneTitle forState:UIControlStateNormal];
        }else{
            [buttOne setBackgroundImage:locked forState:UIControlStateNormal ];
        }

        [self.contentView addSubview:buttOne];
        
        startPoint += spander;
    }
}


-(void)buttnActionion:(UIButton*)sender{

  NSLog(@"button.tag is %ld",sender.tag);
    [self dismMenumentWithSelector:sender];
    
    TastingController* tesvwContller=[[TastingController alloc]init];
    tesvwContller.indoxes=sender.tag;
    
    
    //获取navigationController来push GameController进去
    if (sender.tag<=self.thorMaIndx) {
        AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
        [(UINavigationController *)appDelegate.window.rootViewController pushViewController:tesvwContller animated:YES];
        NSLog(@"%@",appDelegate.window.rootViewController);
    }

    else{
        NSLog(@"you can't get into it because you not break in");
    }
}

- (void)dismMenumentWithSelector:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                        // [self dismissMenu];
                         button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                     }];
}

- (UIViewController *)getPresentorVwContrller
{
    UIViewController *rootViwC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topperVwCn = rootViwC;
    if (topperVwCn.presentedViewController) {
        topperVwCn = topperVwCn.presentedViewController;
    }
    
    return topperVwCn;
}

- (UIViewController *)gottoryCurrentVC
{
    UIViewController *resltory;
    
    UIWindow * widw = [[UIApplication sharedApplication] keyWindow];
    if (widw.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windowList = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmperWin in windowList)
        {
            if (tmperWin.windowLevel == UIWindowLevelNormal)
            {
                widw = tmperWin;
                break;
            }
        }
    }
    
    UIView *vFront = [[widw subviews] objectAtIndex:0];
    id nextRespdr = [vFront nextResponder];
    
    if ([nextRespdr isKindOfClass:[UIViewController class]])
        resltory = nextRespdr;
    else
        resltory = widw.rootViewController;
    
    return resltory;
}

@end
