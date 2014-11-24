//
//  FMPATConfigurationViewController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 24.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPATConfigurationViewController.h"
#import "SVProgressHUD.h"
#import "FMPHelpers.h"
#import "FMPApiController.h"

typedef enum : NSUInteger {
    FMPPeriod_10SEC = 10,
    FMPPeriod_30SEC = 30,
    FMPPeriod_1MIN  = 60,
    FMPPeriod_5MIN  = 5*60,
    FMPPeriod_10MIN = 10*60,
    FMPPeriod_30MIN = 30*60,
    FMPPeriod_1HOUR = 60*60,
    FMPPeriod_1DAY  = 24*60*60
} FMPPeriod;

@interface FMPATConfigurationViewController ()

@property (weak, nonatomic) IBOutlet UIView* scrollableView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UITextField* deviceNameTextField;
@property (weak, nonatomic) IBOutlet UIButton* submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *reportPeriodControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationPeriodControl;

@end

@implementation FMPATConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];

    [self resetChanges];
}

- (void)resetChanges {

    [FMPApiController getSettingsForDeviceWithId:[self.device[@"id"] integerValue] withCompletionHandler:^(BOOL success, NSDictionary *settings, NSError *error) {

        if (success && settings) {

            if (!settings[@"email"] || [settings[@"email"] isKindOfClass:[NSNull class]]) {
                self.deviceNameTextField.placeholder = @"Not configured";
                self.deviceNameTextField.text = @"";
            } else {
                self.deviceNameTextField.text = settings[@"email"];
            }

            if (!settings[@"email_period"] || [settings[@"email_period"] isKindOfClass:[NSNull class]]) {
                self.reportPeriodControl.selectedSegmentIndex = -1;
            } else {
                NSInteger period = [settings[@"email_period"] integerValue];
                switch (period) {
                    case FMPPeriod_30SEC:
                        self.reportPeriodControl.selectedSegmentIndex = 0;
                        break;
                    case FMPPeriod_1MIN:
                        self.reportPeriodControl.selectedSegmentIndex = 1;
                        break;
                    case FMPPeriod_10MIN:
                        self.reportPeriodControl.selectedSegmentIndex = 2;
                        break;
                    case FMPPeriod_1HOUR:
                        self.reportPeriodControl.selectedSegmentIndex = 3;
                        break;
                    case FMPPeriod_1DAY:
                        self.reportPeriodControl.selectedSegmentIndex = 4;
                        break;
                    default:
                        self.reportPeriodControl.selectedSegmentIndex = -1;
                        break;
                }
            }

            if (!settings[@"period"] || [settings[@"period"] isKindOfClass:[NSNull class]]) {
                self.locationPeriodControl.selectedSegmentIndex = -1;
            } else {
                NSInteger period = [settings[@"period"] integerValue];
                switch (period) {
                    case FMPPeriod_10SEC:
                        self.locationPeriodControl.selectedSegmentIndex = 0;
                        break;
                    case FMPPeriod_30SEC:
                        self.locationPeriodControl.selectedSegmentIndex = 1;
                        break;
                    case FMPPeriod_1MIN:
                        self.locationPeriodControl.selectedSegmentIndex = 2;
                        break;
                    case FMPPeriod_5MIN:
                        self.locationPeriodControl.selectedSegmentIndex = 3;
                        break;
                    case FMPPeriod_30MIN:
                        self.locationPeriodControl.selectedSegmentIndex = 4;
                        break;
                    default:
                        self.locationPeriodControl.selectedSegmentIndex = -1;
                        break;
                }
            }

        }


    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self resetChanges];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.deviceController.segmentedControl.selectedSegmentIndex = 2;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification {

    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey];

    CGRect keyboardEndFrame = [self.view convertRect:[endFrameValue CGRectValue] fromView:nil];
    NSTimeInterval duration = durationValue.doubleValue;
    NSInteger curve = animationCurve.integerValue;

    NSInteger options = curve << 16;

    float posYDiff = CGRectGetMaxY(self.scrollableView.frame) - CGRectGetMinY(keyboardEndFrame);
    self.bottomSpaceConstraint.constant = MAX(posYDiff + 30, 0);

    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];

}

- (void)keyboardWillHide:(NSNotification*)notification {

    NSDictionary *userInfo = notification.userInfo;

    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey];

    NSTimeInterval duration = durationValue.doubleValue;
    NSInteger curve = animationCurve.integerValue;

    NSInteger options = curve << 16;

    self.bottomSpaceConstraint.constant = 0;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];

}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self.scrollView setContentOffset:CGPointZero animated:YES];

    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    textField.layer.borderWidth = 0;

    return YES;
}


#pragma mark - IBActions

- (IBAction)submitButtonClicked:(id)sender {

    if (self.deviceNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Email field cannot stay empty!"];
        return;
    }

    if (![FMPHelpers validateEmail:self.deviceNameTextField.text]) {

        [SVProgressHUD showErrorWithStatus:@"Incorrent Email Address!"];
        return;
    }

    if (self.reportPeriodControl.selectedSegmentIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"Please select Report period!"];
        return;
    }

    if (self.locationPeriodControl.selectedSegmentIndex == -1) {
        [SVProgressHUD showErrorWithStatus:@"Please select Location update period!"];
        return;
    }

    NSString *email = self.deviceNameTextField.text ? : @"";
    NSInteger reportPeriod;
    switch (self.reportPeriodControl.selectedSegmentIndex) {
        case 0:
            reportPeriod = FMPPeriod_30SEC;
            break;
        case 1:
            reportPeriod = FMPPeriod_1MIN;
            break;
        case 2:
            reportPeriod = FMPPeriod_10MIN;
            break;
        case 3:
            reportPeriod = FMPPeriod_1HOUR;
            break;
        case 4:
            reportPeriod = FMPPeriod_1DAY;
            break;
        default:
            reportPeriod = FMPPeriod_30SEC;
            break;
    }

    NSInteger locationPeriod;
    switch (self.locationPeriodControl.selectedSegmentIndex) {
        case 0:
            locationPeriod = FMPPeriod_10SEC;
            break;
        case 1:
            locationPeriod = FMPPeriod_30SEC;
            break;
        case 2:
            locationPeriod = FMPPeriod_1MIN;
            break;
        case 3:
            locationPeriod = FMPPeriod_5MIN;
            break;
        case 4:
            locationPeriod = FMPPeriod_30MIN;
            break;
        default:
            locationPeriod = FMPPeriod_10SEC;
            break;
    }

    if (reportPeriod < locationPeriod) {
        [SVProgressHUD showErrorWithStatus:@"Report period has to be no less than location update period"];
        return;
    }

    NSLog(@"Sending:\nEmail: %@\nEmail_period: %d\nPeriod: %d", email, reportPeriod, locationPeriod);

    [FMPApiController updateATSettingsForDeviceWithID:[self.device[@"id"] integerValue] email:email emailPeriod:reportPeriod period:locationPeriod completionHandler:^(BOOL success, NSError *error) {


    }];
}


- (IBAction)cancelButtonClicked:(id)sender {
    [self resetChanges];
}

@end
