//
//  Popup.m
//  PopupDemo
//
//  Created by Mark Miscavage on 4/16/15.
//  Copyright (c) 2015 Mark Miscavage. All rights reserved.
//

#import "Popup.h"


static const CGFloat kPopupTitleFontSize = 40;
static const CGFloat kPopupSubTitleFontSize = 25;

NSString const *SwipeVertical = @"VERTICAL";

#define FlatWhiteColor [UIColor colorWithRed:0.937 green:0.945 blue:0.961 alpha:1] /*#eff1f5*/
#define FlatWhiteDarkColor [UIColor colorWithRed:0.875 green:0.882 blue:0.91 alpha:1] /*#dfe1e8*/

CGFloat currentKeyboardHeight = 0.0f;
CGFloat popupDimensionWidth = 300.0f;
CGFloat popupDimensionHeight = 300.0f;

BOOL isBlurSet = YES;

@interface Popup () <UITextFieldDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate /*For swiping to dimiss*/> {
    
    UIView *backgroundView;
    UIView *popupView;
    
    UIScreen *mainScreen;
    
    blocky pSuccessBlock;
    blocky pCancelBlock;
    
    PopupBackGroundBlurType popupBlurType;
    
    PopupIncomingTransitionType incomingTransitionType;
    PopupOutgoingTransitionType outgoingTransitionType;
    
    NSString *pTitle;
    NSString *pSubTitle;
    
    NSArray *pTextFieldPlaceholderArray;
    NSArray *pTextFieldArray;
    
    NSString *pCancelTitle;
    NSString *pSuccessTitle;
    
    UIButton *successBtn;
    UIButton *cancelBtn;
    
    UILabel *titleLabel;
    UITextView *subTitleLabel;
    
    NSMutableArray *panHolder;
    
    UIButton *okButton;
    UIButton *backButton;
    UIButton *voiceButton;
    UIButton *nextButton;
    UIButton *renewButton;
    
    BOOL  pHaveOkButton;
    BOOL pHaveBackButton;
    BOOL pHaveVoiceButton;
    BOOL pHaveNextButton;
    BOOL pHaveRenewButton;
}

@end
@implementation Popup

#pragma mark - Instance Types
- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                 haveOkButton:(BOOL)haveOkButton
               haveBackButton:(BOOL)haveBackButton
              haveVoiceButton:(BOOL)haveVoiceButton
               haveNextButton:(BOOL)haveNextButton
                haveRenewButton:(BOOL)haveRenewButton{
    if ([super init]) {
        pTitle = title;
        pSubTitle = subTitle;
        pHaveOkButton=haveOkButton;
        pHaveBackButton=haveBackButton;
        pHaveVoiceButton=haveVoiceButton;
        pHaveNextButton=haveNextButton;
        pHaveRenewButton=haveRenewButton;
        
        
        [self formulateEverything];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                  cancelTitle:(NSString *)cancelTitle
                 successTitle:(NSString *)successTitle {
    
    if ([super init]) {
        pTitle = title;
        pSubTitle = subTitle;
        pCancelTitle = cancelTitle;
        pSuccessTitle = successTitle;
        
        [self formulateEverything];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
        textFieldPlaceholders:(NSArray *)textFieldPlaceholderArray
                  cancelTitle:(NSString *)cancelTitle
                 successTitle:(NSString *)successTitle
                  cancelBlock:(blocky)cancelBlock
                 successBlock:(blocky)successBlock {
    
    if ([super init]) {
        pTitle = title;
        pSubTitle = subTitle;
        pTextFieldPlaceholderArray = textFieldPlaceholderArray;
        pCancelTitle = cancelTitle;
        pSuccessTitle = successTitle;
        pCancelBlock = cancelBlock;
        pSuccessBlock = successBlock;
        
        [self formulateEverything];
    }
    
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                  cancelTitle:(NSString *)cancelTitle
                 successTitle:(NSString *)successTitle
                  cancelBlock:(blocky)cancelBlock
                 successBlock:(blocky)successBlock {
    
    if ([super init]) {
        pTitle = title;
        pSubTitle = subTitle;
        pSuccessBlock = successBlock;
        pCancelTitle = cancelTitle;
        pSuccessTitle = successTitle;
        pCancelBlock = cancelBlock;
        
        [self formulateEverything];
    }
    
    return self;
}

#pragma mark - Creation Methods

- (void)formulateEverything {
    mainScreen =  [UIScreen mainScreen];
    
    [self setFrame:mainScreen.bounds];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:YES];
    
    [self makeAlertPopupView];
    
    [self setupTitle];
    [self setupSubtitle];
    [self setupTextFields];
    [self setupButtons];
}

- (void)blurBackgroundWithType:(PopupBackGroundBlurType)blurType {
    
    UIVisualEffect *blurEffect;

    switch (blurType) {
        case PopupBackGroundBlurTypeDark:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            break;
        case PopupBackGroundBlurTypeExtraLight:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            break;
        case PopupBackGroundBlurTypeLight:
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            break;
        case PopupBackGroundBlurTypeNone:
            //return;
            break;
        default:
            break;
    }
    
    backgroundView = [[UIView alloc] initWithFrame:mainScreen.bounds];

    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [visualEffectView setFrame:backgroundView.bounds];
    [backgroundView addSubview:visualEffectView];
    

    
    [backgroundView setAlpha:0.0];
        //只在无背景图时候点击背景等于取消
    if (blurType==PopupBackGroundBlurTypeNone) {
        [backgroundView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(dismissPopup:)]];
    }

    
    [self insertSubview:backgroundView belowSubview:popupView];
}

- (void)makeAlertPopupView {
    
    CGRect rect = CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight);
    
    popupView = [[UIView alloc] initWithFrame:rect];
    
    [popupView setBackgroundColor:FlatWhiteColor];
    [popupView.layer setMasksToBounds:YES];
    [popupView.layer setCornerRadius:8.0];
    [popupView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [popupView.layer setBorderWidth:1.0];
    
    [self addSubview:popupView];
}

#pragma mark - Accessor Methods

- (void)setBackgroundBlurType:(PopupBackGroundBlurType)backgroundBlurType {
    [self blurBackgroundWithType:backgroundBlurType];
}

- (void)setIncomingTransition:(PopupIncomingTransitionType)incomingTransition {
    incomingTransitionType = incomingTransition;
}

- (void)setOutgoingTransition:(PopupOutgoingTransitionType)outgoingTransition {
    outgoingTransitionType = outgoingTransition;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [popupView setBackgroundColor:backgroundColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    [popupView.layer setBorderColor:borderColor.CGColor];
    [popupView.layer setBorderWidth:1.0];
}

- (void)setTitleColor:(UIColor *)titleColor {
    [titleLabel setTextColor:titleColor];
}

- (void)setSubTitleColor:(UIColor *)subTitleColor {
    [subTitleLabel setTextColor:subTitleColor];
}

- (void)setSuccessBtnColor:(UIColor *)successBtnColor {
    [successBtn setBackgroundColor:successBtnColor];
}

- (void)setSuccessTitleColor:(UIColor *)successTitleColor {
    [successBtn setTitleColor:successTitleColor forState:UIControlStateNormal];
}

- (void)setCancelBtnColor:(UIColor *)cancelBtnColor {
    [cancelBtn setBackgroundColor:cancelBtnColor];
}

- (void)setCancelTitleColor:(UIColor *)cancelTitleColor {
    [cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
}

- (void)setRoundedCorners:(BOOL)roundedCorners {
    if (roundedCorners) {
        [popupView.layer setMasksToBounds:YES];
        [popupView.layer setCornerRadius:8.0];
    }
    else {
        [popupView.layer setMasksToBounds:YES];
        [popupView.layer setCornerRadius:0.0];
    }
}

- (void)setOverallKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
 
    for (int i = 0; i < [pTextFieldArray count]; i++) {
        UITextField *textField = pTextFieldArray[i];
        [textField setKeyboardAppearance:keyboardAppearance];
    }
    
}

- (void)setTapBackgroundToDismiss:(BOOL)tapBackgroundToDismiss {

    if (tapBackgroundToDismiss) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup:)];
        [tap setNumberOfTapsRequired:1];
        [backgroundView addGestureRecognizer:tap];
    }
}

- (void)setSwipeToDismiss:(BOOL)swipeToDismiss {

    if (swipeToDismiss) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [pan setDelegate:self];
        [pan setMinimumNumberOfTouches:1];
        [pan setMaximumNumberOfTouches:1];
        [popupView addGestureRecognizer:pan];
        
        if (!panHolder) {
            panHolder = [NSMutableArray array];
        }
    }
}

#pragma mark - Setup Methods

- (void)setupTitle {
    
    if (pTitle) {
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, popupView.frame.size.width - 16, 40)];
            [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:kPopupTitleFontSize]];
            [titleLabel setAdjustsFontSizeToFitWidth:YES];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setTextColor:[UIColor colorWithRed:0.329 green:0.396 blue:0.584 alpha:1] /*#546595*/];
        }
        
        [titleLabel setText:pTitle];

        [popupView addSubview:titleLabel];
    }
}

- (void)setupSubtitle {
    
    if (pSubTitle) {
        
        int titleLabelHeight = titleLabel.frame.size.height;

        if (!subTitleLabel) {
            subTitleLabel = [[UITextView alloc] init];
            subTitleLabel.backgroundColor=FlatWhiteColor;
            [subTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:kPopupSubTitleFontSize]];
            //[subTitleLabel setAdjustsFontSizeToFitWidth:YES];
            
            
            
            [subTitleLabel setTextAlignment:NSTextAlignmentLeft ];
            [subTitleLabel setTextColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            //[subTitleLabel setNumberOfLines:20];
             //[subTitleLabel setTextAlignment:NSTextAlignmentLeft];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 10;// 字体的行间距
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:25],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            subTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"输入你的内容" attributes:attributes];
        }
        
        //Adjust the subtitle frame if there are textfields present
        if ([pTextFieldPlaceholderArray count] == 0) {
            [subTitleLabel setFrame:CGRectMake(8, titleLabelHeight + 16, popupView.frame.size.width - 16, popupView.frame.size.height - 16 - 40 - (titleLabelHeight + 16))];
        }
        else {
            int textfieldHeight = 28;
            int buttonHeight = 40;

            if ([pTextFieldPlaceholderArray count] == 1) {
                [subTitleLabel setFrame:CGRectMake(8, titleLabelHeight + 16, popupView.frame.size.width - 16, popupView.frame.size.height - 16 - buttonHeight - (textfieldHeight * 2.65) - (8 * 2.65) - (titleLabelHeight + 16))];
            }
            else if ([pTextFieldPlaceholderArray count] == 2) {
                [subTitleLabel setFrame:CGRectMake(8, titleLabelHeight + 16, popupView.frame.size.width - 16, popupView.frame.size.height - 16 - buttonHeight - (textfieldHeight * 2.75) - (8 * 2.75) - (titleLabelHeight + 16))];
            }
            else if ([pTextFieldPlaceholderArray count] == 3) {
                [subTitleLabel setFrame:CGRectMake(8, titleLabelHeight + 16, popupView.frame.size.width - 16, popupView.frame.size.height - 16 - buttonHeight - (textfieldHeight * 3.5) - (8 * 3.5) - (titleLabelHeight + 16))];
            }
        }
        
        [subTitleLabel setText:pSubTitle];
        
        [popupView addSubview:subTitleLabel];
    }
    subTitleLabel.editable=NO;
}

- (void)setupTextFields {

    if (pTextFieldPlaceholderArray) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)];
        [tap setNumberOfTapsRequired:1];
        [tap setDelegate:self];
        [popupView addGestureRecognizer:tap];
        
        [self setKeyboardNotifications];
        
        int titleHeights = titleLabel.frame.size.height + subTitleLabel.frame.size.height;
        int textFieldHeight = 28;
        
        static UITextField *textField1 = nil;
        static UITextField *textField2 = nil;
        static UITextField *textField3 = nil;
        
        
        for (int i = 0; i < [pTextFieldPlaceholderArray count]; i++) {
            if (i == 0) {
                textField1 = [self textFieldWithPlaceholder:pTextFieldPlaceholderArray[i] numberOfField:1];
            }
            else if (i == 1) {
                textField2 = [self textFieldWithPlaceholder:pTextFieldPlaceholderArray[i] numberOfField:2];
            }
            else if (i == 2) {
                textField3 = [self textFieldWithPlaceholder:pTextFieldPlaceholderArray[i] numberOfField:3];
            }
            else {
                NSException *exception = [NSException
                                          exceptionWithName:@"Array exceeds limit."
                                          reason:@"Popups can only have at most 3 fields! TextFieldPlaceholderArray exceeds this limit. ¯|_(ツ)_/¯ "
                                          userInfo:nil];
                
                @throw exception;
            }
        }
        
        if ([pTextFieldPlaceholderArray count] == 1) {
            [textField1 setFrame:CGRectMake(8, titleHeights + 24, popupView.frame.size.width - 16, textFieldHeight)];
            
            pTextFieldArray = @[textField1];
            
            [popupView addSubview:textField1];
        }
        else if ([pTextFieldPlaceholderArray count] == 2) {
            [textField1 setFrame:CGRectMake(8, titleHeights + 24, popupView.frame.size.width - 16, textFieldHeight)];
            [textField2 setFrame:CGRectMake(8, titleHeights + textFieldHeight + 32, popupView.frame.size.width - 16, textFieldHeight)];
            
            pTextFieldArray = @[textField1, textField2];
            
            [popupView addSubview:textField1];
            [popupView addSubview:textField2];
        }
        else if ([pTextFieldPlaceholderArray count] == 3) {
            [textField1 setFrame:CGRectMake(8, titleHeights + 24, popupView.frame.size.width - 16, textFieldHeight)];
            [textField2 setFrame:CGRectMake(8, titleHeights + textFieldHeight + 32, popupView.frame.size.width - 16, textFieldHeight)];
            [textField3 setFrame:CGRectMake(8, titleHeights + (textFieldHeight * 2) + 40, popupView.frame.size.width - 16, textFieldHeight)];
            
            pTextFieldArray = @[textField1, textField2, textField3];
            
            [popupView addSubview:textField1];
            [popupView addSubview:textField2];
            [popupView addSubview:textField3];
        }
    }
}

- (void)setupButtons {

    if (pCancelTitle) {
        
        if (!cancelBtn) {
            cancelBtn = [[UIButton alloc] init];
            [cancelBtn setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [cancelBtn setBackgroundColor:[UIColor colorWithRed:0.91 green:0.184 blue:0.184 alpha:1] /*#e82f2f*/];
            [cancelBtn addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [cancelBtn.layer setCornerRadius:6.0];
            [cancelBtn.layer setMasksToBounds:YES];
        }
        
        //Change the frame to expand the whole width of Popup if there's no successBtn
        [cancelBtn setFrame:CGRectMake(8, popupView.frame.size.height - 48, !pSuccessTitle ? popupView.frame.size.width - 16 : popupView.frame.size.width/2 - 12, 40)];

        [cancelBtn setTitle:pCancelTitle forState:UIControlStateNormal];
        
        [popupView addSubview:cancelBtn];
    }
    
    if (pSuccessTitle) {
        
        if (!successBtn) {
            successBtn = [[UIButton alloc] init];
            [successBtn setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [successBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [successBtn setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            [successBtn addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [successBtn.layer setCornerRadius:6.0];
            [successBtn.layer setMasksToBounds:YES];
        }
        
        //Change the frame to expand the whole width of Popup if there's no cancelBtn
        if (!pCancelTitle) {
            [successBtn setFrame:CGRectMake(8, popupView.frame.size.height - 48, popupView.frame.size.width - 16, 40)];
        }
        else {
            [successBtn setFrame:CGRectMake(popupView.frame.size.width/2 + 4, popupView.frame.size.height - 48, popupView.frame.size.width/2 - 12, 40)];
        }
        
        [successBtn setTitle:pSuccessTitle forState:UIControlStateNormal];
        
        [popupView addSubview:successBtn];
    }
    
    
    if (pHaveOkButton)
    {
        if (!okButton)
        {
            okButton = [[UIButton alloc] init];
            [okButton setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [okButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [okButton setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            [okButton addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [okButton.layer setCornerRadius:6.0];
            [okButton.layer setMasksToBounds:YES];
        }
            [okButton setFrame:CGRectMake(8, popupView.frame.size.height - 48, popupView.frame.size.width - 16, 40)];
            [okButton setTitle:@"OK" forState:UIControlStateNormal];
            
            [popupView addSubview:okButton];
        
    }
    
    if (pHaveBackButton&&pHaveNextButton&&pHaveVoiceButton)
    {
        if (!backButton)
        {
            backButton = [[UIButton alloc] init];
            [backButton setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:30.0]];
            [backButton setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            [backButton addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [backButton.layer setCornerRadius:6.0];
            [backButton.layer setMasksToBounds:YES];
        }
        [backButton setFrame:CGRectMake(6, popupView.frame.size.height - 48, popupView.frame.size.width/3 - 8, 40)];
        [backButton setTitle:@"←" forState:UIControlStateNormal];
        
        [popupView addSubview:backButton];
        
        if (!voiceButton)
        {
            voiceButton = [[UIButton alloc] init];
            [voiceButton setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [voiceButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:30.0]];
            [voiceButton setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            [voiceButton addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [voiceButton.layer setCornerRadius:6.0];
            [voiceButton.layer setMasksToBounds:YES];
        }
        
        [voiceButton setFrame:CGRectMake(popupView.frame.size.width/3 + 4, popupView.frame.size.height - 48, popupView.frame.size.width/3 - 8, 40)];
        [voiceButton setTitle:@"🔊" forState:UIControlStateNormal];
        
        [popupView addSubview:voiceButton];
        
        if (!nextButton)
        {
            nextButton = [[UIButton alloc] init];
            [nextButton setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [nextButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:30.0]];
            [nextButton setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            [nextButton addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [nextButton.layer setCornerRadius:6.0];
            [nextButton.layer setMasksToBounds:YES];
        }
        [nextButton setFrame:CGRectMake(popupView.frame.size.width/3*2 + 2, popupView.frame.size.height - 48, popupView.frame.size.width/3 - 8, 40)];
        [nextButton setTitle:@"→" forState:UIControlStateNormal];
        
        [popupView addSubview:nextButton];
    }
    
    if (pHaveRenewButton&&pHaveBackButton) {
        if (!backButton)
        {
            backButton = [[UIButton alloc] init];
            [backButton setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:30.0]];
            [backButton setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            [backButton addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [backButton.layer setCornerRadius:6.0];
            [backButton.layer setMasksToBounds:YES];
        }
        [backButton setFrame:CGRectMake(8, popupView.frame.size.height - 48, popupView.frame.size.width/2 - 12, 40)];
        [backButton setTitle:@"←" forState:UIControlStateNormal];
        
        [popupView addSubview:backButton];
        
        if (!renewButton)
        {
            renewButton = [[UIButton alloc] init];
            [renewButton setTitleColor:FlatWhiteDarkColor forState:UIControlStateNormal];
            [renewButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:30.0]];
            [renewButton setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.682 alpha:1] /*#687aae*/];
            [renewButton addTarget:self action:@selector(pressAlertButton:) forControlEvents:UIControlEventTouchUpInside];
            [renewButton.layer setCornerRadius:6.0];
            [renewButton.layer setMasksToBounds:YES];
        }
        [renewButton setFrame:CGRectMake(popupView.frame.size.width/2 + 4, popupView.frame.size.height - 48, popupView.frame.size.width/2 - 12, 40)];
        [renewButton setTitle:@"↻" forState:UIControlStateNormal];
        
        [popupView addSubview:renewButton];
    }
    
}

#pragma mark - Presentation Methods

- (void)showPopup {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [window makeKeyAndVisible];
    
    if( [self.delegate respondsToSelector:@selector(popupWillAppear:)] ) {
        [self.delegate popupWillAppear:self];
    }
    
    [self showAnimation];
}

- (void)showAnimation {
    [UIView animateWithDuration:0.1 animations:^{
        [backgroundView setAlpha:1.0];
    }];
    
    [self configureIncomingAnimationFor: incomingTransitionType ? incomingTransitionType : PopupIncomingTransitionTypeAppearCenter];
}

#pragma mark - Dismissing Methods

- (void)dismissPopup:(PopupButtonType)buttonType {
    
    if (buttonType != PopupButtonSuccess && buttonType != PopupButtonCancel) {
        //For tapping and swiping to dismiss
        buttonType = PopupButtonCancel;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupWillDisappear:buttonType:)] ) {
        [self.delegate popupWillDisappear:self buttonType:buttonType];
    }
    
    [self configureOutgoingAnimationFor:outgoingTransitionType ? outgoingTransitionType : PopupOutgoingTransitionTypeDisappearCenter withButtonType:buttonType];
}

#pragma mark - Button Methods

- (void)pressAlertButton:(id)sender {
    
    [self dismissKeyboards];

    UIButton *button = (UIButton *)sender;
    
    PopupButtonType buttonType;
    
    BOOL isBlock = false;
    
    if ([button isEqual:successBtn]) {
        NSLog(@"Success!");
        
        buttonType = PopupButtonSuccess;
        if (pSuccessBlock) isBlock = true;
    }
    else if([button isEqual:cancelBtn]){
        NSLog(@"Cancel!");
        
        buttonType = PopupButtonCancel;
        if (pCancelBlock) isBlock = true;
    }
    else if([button isEqual:okButton]){
        NSLog(@"OK!");
        
        buttonType = PopupButtonOk;
        isBlock = true;
        
    }
    else if([button isEqual:backButton]){
        NSLog(@"Back!");
        
        buttonType = PopupButtonBack;
        isBlock = true;
    }
    else if([button isEqual:voiceButton]){
        NSLog(@"Voice!");
        
        buttonType = PopupButtonVoice;
        isBlock = true;
    }
    else if([button isEqual:nextButton]){
        NSLog(@"Next!");
        
        buttonType = PopupButtonNext;
        isBlock = true;
    }
    else if([button isEqual:renewButton]){
        NSLog(@"Renew!");
        
        buttonType = PopupButtonRenew;
        isBlock = true;
    }
    
    if ([self.delegate respondsToSelector:@selector(popupPressButton:buttonType:)]) {
        [self.delegate popupPressButton:self buttonType:buttonType];
    }
    
    if (self.delegate && [pTextFieldPlaceholderArray count] > 0 && [self.delegate respondsToSelector:@selector(dictionary:forpopup:stringsFromTextFields:)]) {
        [self.delegate dictionary:[self createDictionaryForTextfields] forpopup:self stringsFromTextFields:[self arrayForStringOfTextfields]];
    }
    
    if ([button isEqual:nextButton]||[button isEqual:okButton]||[button isEqual:backButton]||[button isEqual:renewButton]||[button isEqual:successBtn] ||[button isEqual:cancelBtn]) {
        [self dismissPopup:buttonType];
    }
    
}

#pragma mark - UIPanGestureRecognizer Methods

- (void)panFired:(id)sender {
    //Make sure this delegate method only gets called once
    static int i = 1;
    if (i == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupWillDisappear:buttonType:)] ) {
            [self.delegate popupWillDisappear:self buttonType:PopupButtonCancel];
            i = 0;
        }
    }
    
    UIPanGestureRecognizer *panRecog = (UIPanGestureRecognizer *)sender;
    CGPoint vel = [panRecog velocityInView:popupView];
    
    UIView *recogView = [panRecog view];
    
    CGPoint translation = [panRecog translationInView:popupView];
    CGFloat curY = popupView.frame.origin.y;
    
    [self endEditing:YES];
    
    if (panRecog.state == UIGestureRecognizerStateChanged) {
        //drag view vertially
        CGRect frame = popupView.frame;
        frame.origin.y = curY + translation.y;
        recogView.frame = frame;
        [panRecog setTranslation:CGPointMake(0.0f, 0.0f) inView:popupView];
    }
    else if (panRecog.state == UIGestureRecognizerStateEnded) {
        
        CGFloat finalX = popupView.frame.origin.x;
        CGFloat finalY = 50.0f;
        CGFloat curY = popupView.frame.origin.y;
        
        CGFloat distance = curY - finalY;
        
        //Normalize velocity
        //Multiply by -1 in this case since final desitination y < curY
        //and recog's y velocity is negative when draggin up
        //(therefore also works when released when dragging down)
        CGFloat springVelocity = -1.0f * vel.y / distance;
        
        //If the springVelocity is really slow, speed it up a bit
        if (springVelocity > 1.5f) {
            springVelocity = -1.5f;
        }
        
        [UIView animateWithDuration:springVelocity delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            CGRect frame = popupView.frame;
            frame.origin.x = finalX;
            frame.origin.y = finalY;
            popupView.frame = frame;
            
            [backgroundView setAlpha:0.0];
            if (curY > 115.1) {
                [UIView animateWithDuration:0.1 animations:^{
                    popupView.frame = CGRectMake(30, 600, popupDimensionWidth, popupDimensionHeight);
                } completion:^(BOOL finished) {
                    popupView.alpha = 0.0;
                }];
            }
            else {
                [UIView animateWithDuration:0.1 animations:^{
                    popupView.frame = CGRectMake(30, -400, popupDimensionWidth, popupDimensionHeight);
                } completion:^(BOOL finished) {
                    popupView.alpha = 0.0;
                }];
            }
            
        } completion:^(BOOL finished) {
            [self endWithButtonType:PopupButtonCancel];
        }];
 
    }
}

#pragma mark - Textfield Getter Methods

- (NSMutableDictionary *)createDictionaryForTextfields {
    
    static NSMutableDictionary *dictionary = nil;
    
    if (!dictionary) dictionary = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [pTextFieldArray count]; i++) {
        if (i == 0) {
            UITextField *textField1 = pTextFieldArray[i];
            
            [dictionary setObject:textField1.text forKey:pTextFieldPlaceholderArray[i]];
        }
        else if (i == 1) {
            UITextField *textField2 = pTextFieldArray[i];
            
            [dictionary setObject:textField2.text forKey:pTextFieldPlaceholderArray[i]];
        }
        else if (i == 2) {
            UITextField *textField3 = pTextFieldArray[i];
            
            [dictionary setObject:textField3.text forKey:pTextFieldPlaceholderArray[i]];
        }
    }
    
    return dictionary;
}

- (NSArray *)arrayForStringOfTextfields {
    
    NSString *textField1String = nil;
    NSString *textField2String = nil;
    NSString *textField3String = nil;
    
    
    for (int i = 0; i < [pTextFieldArray count]; i++) {
        if (i == 0) {
            UITextField *textField1 = pTextFieldArray[i];
            textField1String = textField1.text;
        }
        else if (i == 1) {
            UITextField *textField2 = pTextFieldArray[i];
            textField2String = textField2.text;
        }
        else if (i == 2) {
            UITextField *textField3 = pTextFieldArray[i];
            textField3String = textField3.text;
        }
        else {
            NSException *exception = [NSException
                                      exceptionWithName:@"Array exceeds limit."
                                      reason:@"Popups can only have at most 3 fields, TextFieldArray exceeds this limit."
                                      userInfo:nil];
            
            @throw exception;
        }
    }
    
    if ([pTextFieldPlaceholderArray count] == 1) {
        return @[textField1String];
    }
    else if ([pTextFieldPlaceholderArray count] == 2) {
        return @[textField1String, textField2String];
    }
    else if ([pTextFieldPlaceholderArray count] == 3) {
        return @[textField1String, textField2String, textField3String];
    }
    else return nil;
    
}

#pragma mark - UITextField Methods

- (void)setTextFieldTypeForTextFields:(NSArray *)textFieldTypeArray {
    
    NSArray *canBeArray = @[@"",
                            @"DEFAULT",
                            @"PASSWORD"];
    
    int counter = 0;

    for (NSString *type in textFieldTypeArray) {
        if ([type isKindOfClass:[NSString class]]) {
            if ([canBeArray containsObject:type]) {
                if ([type isEqualToString:@"PASSWORD"]) {
                    if (counter < 3) {
                        
                        UITextField *field = pTextFieldArray[counter];
                        [field setSecureTextEntry:YES];
                    
                    }
                    else {
                        NSException *exception = [NSException
                                                  exceptionWithName:@"Array exceeds limit."
                                                  reason:@"Popups can only have at most 3 fields, TextFieldTypeArray exceeds this limit."
                                                  userInfo:nil];
                        
                        @throw exception;
                    }
                }
            }
            else {
                NSString *canBeString = [canBeArray componentsJoinedByString:@", "];
                
                NSException *exception = [NSException
                                          exceptionWithName:@"Not a valid textfield type."
                                          reason:[NSString stringWithFormat:@"TextField type needs to be of type NSString and either: %@", canBeString]
                                          userInfo:nil];
                @throw exception;
            }
        }
        else {
            NSException *exception = [NSException
                                      exceptionWithName:@"Not a valid textfield class type."
                                      reason:@"TextField type needs to be of type NSString."
                                      userInfo:nil];
            @throw exception;
        }
        
        counter ++;
    }
}

- (void)setTextFieldTextForTextFields:(NSArray *)textFieldTextArray {
        
    for (int i = 0; i < [pTextFieldArray count]; i++) {
        
        if (i < 3) {
            UITextField *field = [pTextFieldArray objectAtIndex:i];
            NSString *textToFill = [textFieldTextArray objectAtIndex:i];
            
            if (field && textToFill) {
                if ([field isKindOfClass:[UITextField class]]) {
                    if ([textToFill isKindOfClass:[NSString class]]) {
                        [field setText:textToFill];
                    }
                    else {
                        NSException *exception = [NSException
                                                  exceptionWithName:@"Not valid textfield text."
                                                  reason:@"TextField text needs to be of type NSString."
                                                  userInfo:nil];
                        @throw exception;
                    }
                }
            }
            
        }
        else {
            NSException *exception = [NSException
                                      exceptionWithName:@"Array exceeds limit."
                                      reason:@"Popups can only have at most 3 fields, TextFieldTypeArray exceeds this limit."
                                      userInfo:nil];
            
            @throw exception;
        }
    }
    
}

- (void)setKeyboardTypeForTextFields:(NSArray *)keyboardTypeArray {
    
    NSArray *canBeArray = @[@"",
                            @"DEFAULT",
                            @"ASCIICAPABLE",
                            @"NUMBERSANDPUNCTUATION",
                            @"URL",
                            @"NUMBER",
                            @"PHONE",
                            @"NAMEPHONE",
                            @"EMAIL",
                            @"DECIMAL",
                            @"TWITTER",
                            @"WEBSEARCH"];
    
    int counter = 0;

    for (NSString *type in keyboardTypeArray) {
        if ([type isKindOfClass:[NSString class]]) {
            if ([canBeArray containsObject:type]) {
                if (counter < 3) {
                    UITextField *field = pTextFieldArray[counter];
                    [field setKeyboardType:[self getKeyboardTypeFromString:type]];
                }
                else {
                    NSException *exception = [NSException
                                              exceptionWithName:@"Array exceeds limit."
                                              reason:@"Popups can only have at most 3 fields, KeyboardTypeArray exceeds this limit."
                                              userInfo:nil];
                
                    @throw exception;
                }
            }
            else {
                NSString *canBeString = [canBeArray componentsJoinedByString:@", "];

                NSException *exception = [NSException
                                            exceptionWithName:@"Not a valid textfield type."
                                            reason:[NSString stringWithFormat:@"Keyboard type needs to be of type NSString and either: %@", canBeString]
                                            userInfo:nil];
                @throw exception;
            }
        }
        else {
            NSException *exception = [NSException
                                        exceptionWithName:@"Not a valid textfield class type."
                                        reason:@"Keyboard type needs to be of type NSString."
                                        userInfo:nil];
            @throw exception;
        }
        counter ++;
    }
}

- (UIKeyboardType)getKeyboardTypeFromString:(NSString *)string {
    
    UIKeyboardType keyboardType;

    if ([string isEqualToString:@""]) {
        keyboardType = UIKeyboardTypeDefault;
    }
    else if ([string isEqualToString:@"DEFAULT"]) {
        keyboardType = UIKeyboardTypeDefault;
    }
    else if ([string isEqualToString:@"ASCIICAPABLE"]) {
        keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if ([string isEqualToString:@"NUMBERSANDPUNCTUATION"]) {
        keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([string isEqualToString:@"URL"]) {
        keyboardType = UIKeyboardTypeURL;
    }
    else if ([string isEqualToString:@"NUMBER"]) {
        keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([string isEqualToString:@"PHONE"]) {
        keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([string isEqualToString:@"NAMEPHONE"]) {
        keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if ([string isEqualToString:@"EMAIL"]) {
        keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([string isEqualToString:@"DECIMAL"]) {
        keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([string isEqualToString:@"TWITTER"]) {
        keyboardType = UIKeyboardTypeTwitter;
    }
    else if ([string isEqualToString:@"WEBSEARCH"]) {
        keyboardType = UIKeyboardTypeWebSearch;
    }
    else {
        keyboardType = UIKeyboardTypeDefault;
    }
    
    return keyboardType;
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholderText numberOfField:(int)num {
    
    UITextField *textField;
    textField = [[UITextField alloc] init];
    [textField setKeyboardType:UIKeyboardTypeDefault];
    [textField setBorderStyle:UITextBorderStyleNone];
    [textField setDelegate:self];
    [textField setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    [textField setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9]];
    [textField setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [textField setTag:num];
    [textField setPlaceholder:placeholderText];
    [textField.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:1.0].CGColor];
    [textField.layer setBorderWidth:1.0];
    [textField.layer setCornerRadius:4.0];
    [textField.layer setMasksToBounds:YES];
    
    if (num == [pTextFieldPlaceholderArray count]) {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    else {
        [textField setReturnKeyType:UIReturnKeyNext];
    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [textField setLeftView:paddingView];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    
    return textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField tag] == [pTextFieldPlaceholderArray count]) {
        [self dismissKeyboards];
    }
    else {
        UITextField *fieldAddOne = (UITextField *)[self viewWithTag:[textField tag]+1];
        
        if ([textField tag] == 1) {
            [textField resignFirstResponder];
            [fieldAddOne becomeFirstResponder];
        }
        else if ([textField tag] == 2) {
            [textField resignFirstResponder];
            [fieldAddOne becomeFirstResponder];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self setPopupFrameForTextField:(int)[textField tag]];
    return YES;
}

- (void)setPopupFrameForTextField:(int)num {
    
    currentKeyboardHeight = 216;
    int subtractor = 0;

    //Integrate for iPhone 4, 5, 6, 6+ screen sizes
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        //If is iPhone4
        subtractor = 70;
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568) {
        //If is iPhone5
        subtractor = 30;
    }
    else if ([UIScreen mainScreen].bounds.size.height > 568) {
        //If is iPhone6, 6+
        subtractor = 0; //Redunant but specific
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [popupView setFrame:CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height/2 - currentKeyboardHeight - subtractor, popupDimensionWidth, popupDimensionHeight)];
    }];
}

- (void)dismissKeyboards {
    //Dismiss all and any keyboards
    [self endEditing:YES];
    
    //Reset the frame of Popup
    [UIView animateWithDuration:0.2 animations:^{
        [popupView setFrame:CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight)];
    }];
}

#pragma mark - Keyboard Methods

- (void)setKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    currentKeyboardHeight = kbSize.height;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Transition Methods

- (void)configureIncomingAnimationFor:(PopupIncomingTransitionType)trannyType {

    CGRect mainRect = CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight);
    
    switch (trannyType) {
        case PopupIncomingTransitionTypeBounceFromCenter: {

            popupView.transform = CGAffineTransformMakeScale(0.4, 0.4);

            [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
                popupView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeSlideFromLeft: {
            
            [popupView setFrame:CGRectMake(-popupDimensionWidth, mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight)];
            
            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:mainRect];

            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeSlideFromTop: {
            
            [popupView setFrame:CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), -popupDimensionHeight, popupDimensionWidth, popupDimensionHeight)];
            
            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:mainRect];
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeSlideFromBottom: {
            
            [popupView setFrame:CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height+popupDimensionHeight, popupDimensionWidth, popupDimensionHeight)];
            
            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:mainRect];
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeSlideFromRight: {
            
            [popupView setFrame:CGRectMake(mainScreen.bounds.size.width + popupDimensionWidth, mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight)];
            
            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:mainRect];
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeEaseFromCenter: {
            
            [popupView setAlpha:0.0];
            popupView.transform = CGAffineTransformMakeScale(0.75, 0.75);
            
            [UIView animateWithDuration:0.25 animations:^{
                popupView.transform = CGAffineTransformIdentity;
                [popupView setAlpha:1.0];
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeAppearCenter: {
            
            [popupView setAlpha:0.0];
            
            [UIView animateWithDuration:0.05 animations:^{
                [popupView setAlpha:1.0];
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeFallWithGravity: {
            
            [popupView setFrame:CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), -popupDimensionHeight, popupDimensionWidth, popupDimensionHeight)];
            
            [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
                [popupView setFrame:mainRect];
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
    
            break;
        }
        case PopupIncomingTransitionTypeGhostAppear: {
            
            [popupView setAlpha:0.0];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
                [popupView setAlpha:1.0];

            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        case PopupIncomingTransitionTypeShrinkAppear: {

            [popupView setAlpha:0.0];
            popupView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            
            [UIView animateWithDuration:0.25 animations:^{
                popupView.transform = CGAffineTransformIdentity;
                [popupView setAlpha:1.0];
                
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(popupDidAppear:)]) {
                    [self.delegate popupDidAppear:self];
                }
            }];
            
            break;
        }
        default: {
            break;
        }
    }

}

- (void)configureOutgoingAnimationFor:(PopupOutgoingTransitionType)trannyType withButtonType:(PopupButtonType)buttonType {
    
    //Make the blur/background fade away
    [UIView animateWithDuration:0.175 animations:^{
        [backgroundView setAlpha:0.0];
    }];

    switch (trannyType) {
        case PopupOutgoingTransitionTypeBounceFromCenter: {

            [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
                popupView.transform = CGAffineTransformMakeScale(1.15, 1.15);
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    
                    popupView.transform = CGAffineTransformMakeScale(0.75, 0.75);
                    
                } completion:^(BOOL finished) {
                    [self endWithButtonType:buttonType];
                }];
            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeSlideToLeft: {
            
            CGRect rect = CGRectMake(-popupDimensionWidth, mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight);

            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:rect];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];
            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeSlideToTop: {

            CGRect rect = CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), -popupDimensionHeight, popupDimensionWidth, popupDimensionHeight);

            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:rect];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];

            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeSlideToBottom: {

            CGRect rect = CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height + popupDimensionHeight, popupDimensionWidth, popupDimensionHeight);

            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:rect];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];

            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeSlideToRight: {

            CGRect rect = CGRectMake(mainScreen.bounds.size.width + popupDimensionWidth, mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight);

            [UIView animateWithDuration:0.125 animations:^{
                [popupView setFrame:rect];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];
            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeEaseToCenter: {
            
            [UIView animateWithDuration:0.2 animations:^{
                popupView.transform = CGAffineTransformMakeScale(0.75, 0.75);
                [popupView setAlpha:0.0];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];
            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeDisappearCenter: {
            
            [UIView animateWithDuration:0.25 animations:^{
                popupView.transform = CGAffineTransformMakeScale(0.65, 0.65);
                [popupView setAlpha:0.0];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];
            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeFallWithGravity: {
            
            CGRect initialRect = CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height/2 - (popupDimensionHeight/2), popupDimensionWidth, popupDimensionHeight);
            CGRect endingRect = CGRectMake(mainScreen.bounds.size.width/2 - (popupDimensionWidth/2), mainScreen.bounds.size.height + popupDimensionHeight, popupDimensionWidth, popupDimensionHeight);

            [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:0.24 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionNone animations:^{
                [popupView setFrame:initialRect];

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.35 animations:^{
                    [popupView setFrame:endingRect];

                } completion:^(BOOL finished) {
                    [self endWithButtonType:buttonType];
                }];
            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeGhostDisappear: {
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [popupView setAlpha:0.0];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];
            }];
            
            break;
        }
        case PopupOutgoingTransitionTypeGrowDisappear: {
            
            [UIView animateWithDuration:0.25 animations:^{
                popupView.transform = CGAffineTransformMakeScale(1.25, 1.25);
                [popupView setAlpha:0.0];
                
            } completion:^(BOOL finished) {
                [self endWithButtonType:buttonType];
            }];
            
            break;
        }
        default: {
            break;
        }
    }
    
}

- (void)endWithButtonType:(PopupButtonType)buttonType {

    blocky blockster;
    
    if (buttonType == PopupTypeSuccess) {
        pSuccessBlock ? blockster = pSuccessBlock: nil;
    }
    else {
        pCancelBlock ? blockster = pCancelBlock: nil;
    }
    
    [self removeFromSuperview];
    
    if (blockster) blockster();
    else if (self.delegate && [self.delegate respondsToSelector:@selector(popupDidDisappear:buttonType:)]) {
        [self.delegate popupDidDisappear:self buttonType:buttonType];
    }
}


//点击return 按钮 去掉
//-(void)textFieldDidEndEditing:(UITextView *)textField
//{
//        [textField resignFirstResponder];
//    NSLog(@"aaaaaaaaaa");
//      
//}
//点击屏幕空白处去掉键盘
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//        [subTitleLabel resignFirstResponder];
//    NSLog(@"gfdgdsfgggggggggg");
//}
@end