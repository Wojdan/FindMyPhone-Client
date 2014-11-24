//
//  FMPRegisterViewController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPRegisterViewController.h"
#import "FMPApiController.h"
#import "SVProgressHUD.h"
#import "FMPHelpers.h"
#import "FMPLoginViewController.h"

#define PASSWORD_MIN_LENGTH 5

@interface FMPRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView* scrollableView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UITextField* loginTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField* retypePasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton* registerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomSpaceConstraint;

@end

@implementation FMPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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

#pragma mark - Handful methods

- (BOOL)registrationFormIsValid {

    NSString *errorMessage;

    if (self.loginTextField.text.length == 0) {
        [FMPHelpers shakeView:self.loginTextField showingBorder:YES];
        errorMessage = @"Some fields are empty.";
    }

    if (self.passwordTextField.text.length == 0) {
        [FMPHelpers shakeView:self.passwordTextField showingBorder:YES];
        errorMessage = @"Some fields are empty.";
    }

    if (self.retypePasswordTextField.text.length == 0) {
        [FMPHelpers shakeView:self.retypePasswordTextField showingBorder:YES];
        errorMessage = @"Some fields are empty.";
    }

    if (errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
        return NO;
    }

    if (![FMPHelpers validateEmail:self.loginTextField.text]) {
        errorMessage = @"Incorrect email address.";
        [FMPHelpers shakeView:self.loginTextField showingBorder:YES];
        [SVProgressHUD showErrorWithStatus:errorMessage];
        return NO;
    }

    if (![self.passwordTextField.text isEqualToString:self.retypePasswordTextField.text]) {
        self.passwordTextField.text = nil;
        self.retypePasswordTextField.text = nil;
        errorMessage = @"Passwords must be the same.";
        [FMPHelpers shakeView:self.passwordTextField showingBorder:YES];
        [FMPHelpers shakeView:self.retypePasswordTextField showingBorder:YES];
        [SVProgressHUD showErrorWithStatus:errorMessage];
        return NO;
    }

    if (self.passwordTextField.text.length < PASSWORD_MIN_LENGTH) {
        self.passwordTextField.text = nil;
        self.retypePasswordTextField.text = nil;
        errorMessage = [NSString stringWithFormat:@"Password must have at least %d characters", PASSWORD_MIN_LENGTH];
        [FMPHelpers shakeView:self.passwordTextField showingBorder:YES];
        [FMPHelpers shakeView:self.retypePasswordTextField showingBorder:YES];
        [SVProgressHUD showErrorWithStatus:errorMessage];
        return NO;
    }

    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    textField.layer.borderWidth = 0;

    return YES;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self.scrollView setContentOffset:CGPointZero animated:YES];

    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];

    } else if ([textField isEqual:self.passwordTextField]) {
        [self.retypePasswordTextField becomeFirstResponder];
        
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - IBActions

- (IBAction)cancelButtonClicked:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)submitButtonClicked:(id)sender {

    if (![self registrationFormIsValid]) {
        return;
    }

    [FMPApiController registerUserWithEmailAddress:self.loginTextField.text password:self.passwordTextField.text completionHandler:^(BOOL success, NSError *error) {

        if (success) {

            [self dismissViewControllerAnimated:YES completion:^{

                [[NSNotificationCenter defaultCenter] postNotificationName:REGISTER_SUCCESS_NOTIFICATION object:nil userInfo:@{
                                                                                                                               @"email":self.loginTextField.text,
                                                                                                                               @"password": self.passwordTextField.text
                                                                                                                               }];

            }];
            [self.view endEditing:YES];
        }

    }];
}

@end
