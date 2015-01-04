//
//  ViewController.m
//  FutureText
//
//  Created by Serguei Vinnitskii on 12/29/14.
//  Copyright (c) 2014 Kartoshka. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()  <MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *pickedDate;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set Miminum Date to display by UIDatePicker so users can't schedule for the date in the past
    self.pickedDate.minimumDate = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendSMS:(UIButton *)sender {
    MFMessageComposeViewController *SMSController = [[MFMessageComposeViewController alloc] init];
    
    if ([MFMessageComposeViewController canSendText]) {

        SMSController.recipients = @[@"8136667795"];
        SMSController.body = @"whatsup";
        SMSController.messageComposeDelegate = self;

        
        [self presentViewController:SMSController animated:YES completion:nil];
        
        
    }else {
        NSLog(@"Can't send message");
    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled) NSLog(@"Message Cancelled");
    if (result == MessageComposeResultFailed) NSLog(@"Message Sending Failed");
    if (result == MessageComposeResultSent) NSLog(@"Message Sent! Yay!");
}

- (IBAction)scheduleButton:(UIButton *)sender {
    
    // Checking if UserNotifications (Alerts) are enabled by the user
    UIUserNotificationSettings *currentNotificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    NSLog(@"%@", currentNotificationSettings);
    
    // Display notification to the user to Enable User Notifications
    if (!(currentNotificationSettings.types & UIUserNotificationTypeAlert)) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't schedule alert"
                                                                       message:@"Please to to Seetings > Notifications and enable ALERTS and SOUNDS"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // Dismiss action
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:dismissAction];
        
        // Go to Settings action
        UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"Go To Settings Now"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       
                                                                       // Opens settings
                                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                       
                                                                   }];
        [alert addAction:goToSettingsAction];
        [self presentViewController:alert animated:YES completion:nil];
    
        
    }
    
    // Display notification to the user to Enable Sounds
    if (!(currentNotificationSettings.types & UIUserNotificationTypeSound)) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't schedule alert"
                                                                       message:@"Please to to Seetings > Notifications and enable SOUNDS"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // Dismiss action
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:dismissAction];
        
        // Go to Settings action
        UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"Go To Settings Now"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       
                                                                       // Opens settings
                                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                       
                                                                   }];
        [alert addAction:goToSettingsAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

    // If Sound+Alerts are available -> chedule notifications
    if ((currentNotificationSettings.types & UIUserNotificationTypeSound) && (currentNotificationSettings.types & UIUserNotificationTypeAlert))[self scheduleLocalNotification:self.pickedDate.date];

}


-(void) scheduleLocalNotification: (NSDate *)date
{
    // Create LocalNotification and specify it's parameters
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = 0;
    localNotification.alertBody = @"Scheduled Message Alert!";
    localNotification.alertAction = @"Slide to send message"; // doesn't do anything
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Displays alert to the user about successful schedule of their notification
    UIAlertController *successfulSchedule = [UIAlertController alertControllerWithTitle:@"Note:"
       message:@"Your reminder has been successfully scheduled."
    preferredStyle:UIAlertControllerStyleAlert];
    
    // Dismiss action
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
            style:UIAlertActionStyleDefault
          handler:^(UIAlertAction * action) {}];
    [successfulSchedule addAction:dismissAction];
    [self presentViewController:successfulSchedule animated:YES completion:nil];
}

@end
