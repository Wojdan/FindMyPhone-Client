//
//  FMPDeviceConfigurationViewController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 03.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPDeviceConfigurationViewController.h"
#import "SVProgressHUD.h"
#import "FMPApiController.h"

@interface FMPDeviceConfigurationViewController ()

@property (weak, nonatomic) IBOutlet UIView* scrollableView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UITextField* deviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField* deviceDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField* deviceIDTextField;
@property (weak, nonatomic) IBOutlet UIButton* submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomSpaceConstraint;

@end

@implementation FMPDeviceConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];

    [self resetChanges];
}

- (void)resetChanges {

    self.deviceIDTextField.text = self.device[@"device_id"];
    self.deviceIDTextField.enabled = NO;
    self.deviceNameTextField.placeholder = self.device[@"name"];
    self.deviceDescriptionTextField.placeholder = self.device[@"description"];

    self.deviceNameTextField.text = @"";
    self.deviceDescriptionTextField.text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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
    self.deviceController.segmentedControl.selectedSegmentIndex = 1;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.deviceNameTextField]) {
        [self.deviceDescriptionTextField becomeFirstResponder];
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

- (IBAction)submitButtonClicked:(id)sender {

    if (self.deviceIDTextField.text.length == 0 && self.deviceNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"No changes commited!"];
        return;
    }

    NSString *newName = self.deviceNameTextField.text.length > 3 ? self.deviceNameTextField.text : self.deviceNameTextField.placeholder;
    NSString *newDesc = self.deviceDescriptionTextField.text.length > 3 ? self.deviceDescriptionTextField.text : self.deviceDescriptionTextField.placeholder;

    [FMPApiController updateDeviceWithID:self.device[@"id"] name:newName description:newDesc vendorID:self.deviceIDTextField.text completionHandler:^(BOOL success, NSError *error) {

        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"Device updated"];
            [self.device setValue:newName forKey:@"name"];
            [self.device setValue:newDesc forKey:@"description"];
            [self resetChanges];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh-Devices" object:nil];
        }

    }];
    
}
- (IBAction)deregisterButtonClicked:(id)sender {

    [[[UIAlertView alloc] initWithTitle:@"" message:@"This device is to be deregistered. You won't be able to  receive its location anymore. Are you sure you want to delete it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex != alertView.cancelButtonIndex) {
        [FMPApiController deregisterDeviceWithID:self.device[@"id"] completionHandler:^(BOOL deregistered, NSError *error) {

            if (deregistered) {
                [self.deviceController.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }];
    }

}

- (IBAction)cancelButtonClicked:(id)sender {
    [self resetChanges];
}

@end
