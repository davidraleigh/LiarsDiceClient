//
//  SetUserNameViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "SetUserNameViewController.h"

@interface SetUserNameViewController_iPhone : SetUserNameViewController <UITextFieldDelegate>
{
    __weak IBOutlet UIImageView *userFeedbackImageView;
    __weak IBOutlet UITextField *usernameTextField;
}
- (IBAction)usernameTextFieldChanged:(id)sender;
- (IBAction)saveUsernameButton:(id)sender;
- (IBAction)mainMenuButton:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
@end
