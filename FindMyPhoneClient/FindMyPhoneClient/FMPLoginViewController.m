//
//  FMPLoginViewController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AppDelegate.h"

#import "FMPLoginViewController.h"
#import "FMPRegisterViewController.h"
#import "FMPHelpers.h"
#import "FMPApiController.h"

#import "SVProgressHUD.h"

@interface FMPLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView* scrollableView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UITextField* loginTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton* signInButton;
@property (weak, nonatomic) IBOutlet UIButton* registerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomSpaceConstraint;

@end

@implementation FMPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillLoginUsingNotification:) name:REGISTER_SUCCESS_NOTIFICATION object:nil];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)fillLoginUsingNotification:(NSNotification*)notification {

    self.loginTextField.text = notification.userInfo[@"email"] ? : @"";
    self.passwordTextField.text = notification.userInfo[@"password"] ? : @"";

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

- (BOOL)loginFormValid {

    NSString *errorMessage;
    if (self.loginTextField.text.length == 0) {
        [FMPHelpers shakeView:self.loginTextField showingBorder:YES];
        errorMessage = @"Login or password is missing.";
    }

    if (self.passwordTextField.text.length == 0) {
        [FMPHelpers shakeView:self.passwordTextField showingBorder:YES];
        errorMessage = @"Login or password is missing.";
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

    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self.scrollView setContentOffset:CGPointZero animated:YES];

    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    textField.layer.borderWidth = 0;

    return YES;
}

#pragma mark - IBActions

- (IBAction)registerButtonClicked:(id)sender {

    FMPRegisterViewController *registerVC = [[UIStoryboard storyboardWithName:@"RegisterViewController" bundle:nil] instantiateInitialViewController];

    [self presentViewController:registerVC animated:YES completion:nil];

}

- (IBAction)signInButtonClicked:(id)sender {

    if (![self loginFormValid]) {
        return;
    }

    [FMPApiController loginWithEmailAddress:self.loginTextField.text password:self.passwordTextField.text completionHandler:^(BOOL success, NSError *error) {

        if (success) {


            UIViewController *devicesVC = [[UIStoryboard storyboardWithName:@"DevicesViewController" bundle:nil] instantiateInitialViewController];
            [AppDelegate setRootViewController:devicesVC ? : [UIViewController new]];
            
            NSLog(@"Zalogowono");

            [self.view endEditing:YES];
        }
        
    }];

}

@end
