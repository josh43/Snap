//
//  LoginAndRegisterViewController.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/27/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "Get.h"
#import "Post.h"
#import "SnapCreate.h"
#import "SnapDelete.h"
#import "MainViewController.h"

@interface LoginAndRegisterViewController ()

@end
static NSString * basicErrorMessage = @"Username and password must both be at least 4 characters and at most 12 characters long ";

@implementation LoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchedLogin:(id)sender {



    if([self basicChecker] == NO){
        return;
    }

    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    LoginAndRegisterViewController * weakMe = self;

    [Get  login:weakMe->_usernameTextField.text andPass:weakMe->_passwordTextField.text  withComp:^(BOOL success, id res) {
        dispatchAsyncMainQueue([weakMe->_activityIndicator stopAnimating];

                if(!success){
                    basicAlertMessage(@"Unable to login at this time :(");
                }else if(!res){
                    basicAlertMessage(@"Unable to login at this time :(");
                }else if(res[@"Error"]){
                    basicAlertMessage(res[@"Error"][@"Message"]);
                }else{
                    /// wee
                    // my mis spellings are disastrous
                    //[SnapDelete deleteDefaultUser];
                    UserInfo * usa;
                    if((usa = [SnapRead findUserWithName:usa.username]) == nil){
                        usa = [SnapCreate createUserWithName:weakMe->_usernameTextField.text andPasword:weakMe->_passwordTextField.text];
                    }

                    [SnapUpdate setCurrentUserInfoTo:usa];
                    [self onCompletion];
                }

                [self enableAllButtons];
                self.activityIndicator.hidden = YES;
        );

    }];
}


- (IBAction)touchedRegister:(id)sender {
    if([self basicChecker] == NO){
        return;
    }
    LoginAndRegisterViewController * weakMe = self;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];

    self.activityIndicator.hidden = NO;
    [Post userRegister:weakMe->_usernameTextField.text withPass:weakMe->_passwordTextField.text andEmail:@"Dont@worryaboutit.com" andFirstname:@"awesomeSawce" andLastname:@"Okaaay" withComp:^(BOOL success, id res) {
        dispatchAsyncMainQueue([weakMe->_activityIndicator stopAnimating];

                if(!success){
                    basicAlertMessage(@"Unable to login at this time :(");
                }else if(!res){
                    basicAlertMessage(@"Unable to login at this time :(");
                }else if(res[@"Error"]){
                    basicAlertMessage(res[@"Error"][@"Message"]);
                }else{
                    /// wee
                    // my mis spellings are disastrous
                    //[SnapDelete deleteDefaultUser];
                    UserInfo * usa = [SnapCreate createUserWithName:weakMe->_usernameTextField.text andPasword:weakMe->_passwordTextField.text];
                    [SnapUpdate setCurrentUserInfoTo:usa];
                    [self onCompletion];

                }
                self.activityIndicator.hidden = YES;
                [self enableAllButtons];

        );
    }];

}
- (void)onCompletion {
    MainViewController * mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];

    [self presentViewController:mainVC animated:YES   completion:nil];
}

-(BOOL) basicChecker{
    [self disableAllButtons];
    if(![self passedTests:self.usernameTextField.text andPass:self.passwordTextField.text]){
        [self enableAllButtons];
        basicAlertMessage(basicErrorMessage);
        return NO;

    }
    return YES;
}
-(BOOL) passedTests:(NSString *)username andPass:(NSString *)pass{
    if(!(username.length >= 4 && username.length <= 12)){
        return NO;
    }//TODO: wayyyyy more testing :D

    return YES;
}
-(void) disableAllButtons{
    _usernameTextField.enabled = NO;
    _passwordTextField.enabled = NO;
    _loginButton.enabled = NO;
    _registerButton.enabled = NO;
}
-(void) enableAllButtons{
    _usernameTextField.enabled = YES;
    _passwordTextField.enabled = YES;
    _loginButton.enabled =       YES;
    _registerButton.enabled =    YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
