//
//  GDWalkThrghView.m
//  GHWalkThrough
//
//  Created by Tapasya on 21/01/14.
//  Copyright (c) 2014 Tapasya. All rights reserved.
//

#import "GDWalkThrghView.h"

@interface GDWalkThrghView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

//@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UIImageView* imgBgFrontLayer;
@property (nonatomic, strong) UIImageView* ivBgBackLayer;

@property (nonatomic, strong) UIPageControl* pgCntrll;
@property (nonatomic, strong) UIButton* skipBttn;

@property (nonatomic, weak) UICollectionViewFlowLayout* flowlayout;

@end

@implementation GDWalkThrghView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self settoryupdate];

    }
    return self;
}

- (void) settoryupdate
{
    self.backgroundColor = [UIColor grayColor];
    
    _imgBgFrontLayer = [[UIImageView alloc] initWithFrame:self.bounds];
    _ivBgBackLayer = [[UIImageView alloc] initWithFrame:self.bounds];
    
    UIView* bagrVw = [[UIView alloc] initWithFrame:self.bounds];
    [bagrVw addSubview:_ivBgBackLayer];
    [bagrVw addSubview:_imgBgFrontLayer];

    UICollectionViewFlowLayout *flwerLayout = [[UICollectionViewFlowLayout alloc] init];
    [flwerLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flwerLayout setMinimumInteritemSpacing:0.0f];
    [flwerLayout setMinimumLineSpacing:0.0f];
    self.flowlayout = flwerLayout;

    _cletionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flwerLayout];
    _cletionView.backgroundColor = [UIColor clearColor];
    _cletionView.backgroundView = bagrVw;
    _cletionView.showsHorizontalScrollIndicator = NO;
    _cletionView.showsVerticalScrollIndicator = NO;
    self.cletionView.dataSource = self;
    self.cletionView.delegate = self;
    [self.cletionView registerClass:[GDWalkThrgPageCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.cletionView setPagingEnabled:YES];
    

    [self addSubview:_cletionView];
    
    [self buildingOutFooterView];

}

- (void)setVFltingHeader:(UIView *)vFltingHeader{
    if (_vFltingHeader != nil) {
        [_vFltingHeader removeFromSuperview];
    }
    
    _vFltingHeader = vFltingHeader;
    CGRect frmot = _vFltingHeader.frame;
    frmot.origin.y = 50;
    frmot.origin.x = self.bounds.size.width/2 - frmot.size.width/2;
    _vFltingHeader.frame = frmot;
    
    [self addSubview:_vFltingHeader];
    [self bringSubviewToFront:_vFltingHeader];
}

- (void)setWalkThrghDirection:(GDWalkThrghViewDirection)walkThrghDirection{
    _walkThrghDirection = walkThrghDirection;
    UICollectionViewScrollDirection direct = _walkThrghDirection == GDWalkThrghViewDirectionVertical ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    UICollectionViewFlowLayout* layout =  (UICollectionViewFlowLayout*) self.cletionView.collectionViewLayout;
    [layout setScrollDirection:direct];
    [layout invalidateLayout];
    [self oriententlyFooter];
}

- (void)setClsTit:(NSString *)clsTit{
    _clsTit = clsTit;
    [self.skipBttn setTitle:_clsTit forState:UIControlStateNormal];
}

- (void) oriententlyFooter
{
    if (self.walkThrghDirection == GDWalkThrghViewDirectionVertical) {
        BOOL isRotation = !CGAffineTransformEqualToTransform(self.pgCntrll.transform, CGAffineTransformIdentity);
        if (!isRotation) {
            CGRect butnFrme = self.skipBttn.frame;
            butnFrme.origin.x -= 30;
            self.skipBttn.frame = butnFrme;
            
            self.pgCntrll.transform = CGAffineTransformRotate(self.pgCntrll.transform, M_PI_2);
            CGRect frmrt = self.pgCntrll.frame;
            frmrt.size.height = ([self.dataSource numberOfPages] + 1 ) * 16;
            frmrt.origin.x = self.bounds.size.width - frmrt.size.width - 10;
            frmrt.origin.y = butnFrme.origin.y+butnFrme.size.height - frmrt.size.height;
            self.pgCntrll.frame = frmrt;
        
        }
    } else{
        BOOL isRotation = !CGAffineTransformEqualToTransform(self.pgCntrll.transform, CGAffineTransformIdentity);
        if (isRotation) {
            // Rotate back the page control
            self.pgCntrll.transform = CGAffineTransformRotate(self.pgCntrll.transform, -M_PI_2);
            self.pgCntrll.frame = CGRectMake(0, self.bounds.size.height - 60, self.bounds.size.width, 20);
            
            self.skipBttn.frame = CGRectMake(self.bounds.size.width - 80, self.pgCntrll.frame.origin.y - ((30 - self.pgCntrll.frame.size.height)/2), 80, 30);

        }
    }
}

- (void)buildingOutFooterView {
    self.pgCntrll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 60, self.bounds.size.width, 20)];

    self.pgCntrll.defersCurrentPageDisplay = YES;
    
    self.pgCntrll.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.pgCntrll addTarget:self action:@selector(showPanelAtPageControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pgCntrll];
    [self bringSubviewToFront:self.pgCntrll];
    
    self.skipBttn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.skipBttn.frame = CGRectMake(self.bounds.size.width - 80, self.pgCntrll.frame.origin.y - ((30 - self.pgCntrll.frame.size.height)/2), 80, 30);
    
    self.skipBttn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.skipBttn setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipBttn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    [self bringSubviewToFront:self.skipBttn];
}

- (void) skipIntroduction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        dispatch_time_t popTmor = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
        dispatch_after(popTmor, dispatch_get_main_queue(), ^(void){
            [self removeFromSuperview];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(walkingoutThroughDidDismissView:)]) {
                [self.delegate walkingoutThroughDidDismissView:self];
            }
        });
	}];
}

- (void)showPanelAtPageControl:(UIPageControl*) sender
{
    [self.pgCntrll setCurrentPage:sender.currentPage];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger nPgers = [self.dataSource numberOfPages];
    return nPgers;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDWalkThrgPageCell *walkCell = (GDWalkThrgPageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(configrationPage:atIndex:)]) {
        [self.dataSource configrationPage:walkCell atIndex:indexPath.row];
    }

    return walkCell;
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.dataSource respondsToSelector:@selector(backgdImageforPage:)]) {
        self.imgBgFrontLayer.image = [self.dataSource backgdImageforPage:self.pgCntrll.currentPage];
    }
   // [self.collectionView reloadData];
    [[NSUserDefaults standardUserDefaults]setInteger:self.pgCntrll.currentPage forKey:@"presenceCell"];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Get scrolling position, and send the alpha values.
    if (!self.isfixBackgrnd) {
        float offsetTop = self.walkThrghDirection == GDWalkThrghViewDirectionHorizontal ? self.cletionView.contentOffset.x / self.cletionView.frame.size.width : self.cletionView.contentOffset.y / self.cletionView.frame.size.height ;
        [self crossesDissolverForOffset:offsetTop];
    }
    
    CGFloat pgMetry = 0.0f;
    CGFloat contnOffs = 0.0f;
    
    switch (self.walkThrghDirection) {
        case GDWalkThrghViewDirectionHorizontal:
            pgMetry = scrollView.frame.size.width;
            contnOffs = scrollView.contentOffset.x;
            break;
        case GDWalkThrghViewDirectionVertical:
            pgMetry = scrollView.frame.size.height;
            contnOffs = scrollView.contentOffset.y;
            break;
    }
    
    int page = floor((contnOffs - pgMetry / 2) / pgMetry) + 1;
    self.pgCntrll.currentPage = page;
}

- (void)crossesDissolverForOffset:(float)offset {
    NSInteger pageIn = (int)(offset);
    float alphaVle = offset - (int)offset;
    
    if (alphaVle < 0 && self.pgCntrll.currentPage == 0){
        self.ivBgBackLayer.image = nil;
        self.imgBgFrontLayer.alpha = (1 + alphaVle);
        return;
    }
    
    self.imgBgFrontLayer.alpha = 1;
    self.imgBgFrontLayer.image = [self.dataSource backgdImageforPage:pageIn];
    self.ivBgBackLayer.alpha = 0;
    self.ivBgBackLayer.image = [self.dataSource backgdImageforPage:pageIn+1];
    
    float bkLayrAlpha = alphaVle;
    float frontLyorAlp = (1 - alphaVle);
    
    bkLayrAlpha = easiedOutVlue(bkLayrAlpha);
    frontLyorAlp = easiedOutVlue(frontLyorAlp);
    
    self.ivBgBackLayer.alpha = bkLayrAlpha;
    self.imgBgFrontLayer.alpha = frontLyorAlp;
}

float easiedOutVlue(float value) {
    float invorise = value - 1.0;
    return 1.0 + invorise * invorise * invorise;
}

- (void) showInfortionView:(UIView *)view animateDuration:(CGFloat) duration
{
    self.pgCntrll.currentPage = 0;
    self.pgCntrll.numberOfPages = [self.dataSource numberOfPages];;

    if (self.isfixBackgrnd) {
        self.imgBgFrontLayer.image = self.brcgImg;
    } else{
        self.imgBgFrontLayer.image = [self.dataSource backgdImageforPage:0];
    }

    self.alpha = 0;
    self.cletionView.contentOffset = CGPointZero;
    [view addSubview:self];

    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}

@end
