//
//  ViewController.m
//  Sentry
//
//  Created by Cathy Wong on 4/20/16.
//  Copyright © 2016 Thrun Lab. All rights reserved.
//

#import "ViewController.h"
#import <Sentry/InceptionInference.pbrpc.h>
#import <GRPCClient/GRPCCall+Tests.h>

// Define the service host address
static NSString *const kHostAddress = @"104.197.50.236:9000";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    // Create a step
    ORKInstructionStep *instructionStep =
    [[ORKInstructionStep alloc] initWithIdentifier:@"intro"];
    instructionStep.title = @"Welcome to the Sentry ResearchKit classifier app.";
    
    ORKNumericAnswerFormat *format =
    [ORKNumericAnswerFormat integerAnswerFormatWithUnit:@"years"];
    format.minimum = @(18);
    format.maximum = @(90);
    ORKQuestionStep *questionStep =
    [ORKQuestionStep questionStepWithIdentifier:@"questionStepIdentifier"
                                          title:@"How old are you?"
                                         answer:format];
    ORKImageCaptureStep *skinLesionCaptureStep =
    [[ORKImageCaptureStep alloc] initWithIdentifier:@"imageCaptureStep"];
    skinLesionCaptureStep.title = @"Take a photo of the lesion";
    
    
    ORKOrderedTask *task =
    [[ORKOrderedTask alloc] initWithIdentifier:@"task" steps:@[instructionStep,questionStep,skinLesionCaptureStep]];
    
    ORKTaskViewController *taskViewController =
    [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    taskViewController.delegate = self;
    
    // Get the output directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    taskViewController.outputDirectory = [[NSURL alloc] initFileURLWithPath:documentsDirectory];
    [self presentViewController:taskViewController animated:YES completion:nil];
}

- (void)taskViewController:(ORKTaskViewController *)taskViewController
       didFinishWithReason:(ORKTaskViewControllerFinishReason)reason
                     error:(NSError *)error {
    
    ORKTaskResult *taskResult = [taskViewController result];
    
    NSLog(@"%@", taskResult);
    NSData* imageData = nil;
    for(ORKResult* stepResult in taskResult.results) {
        if ([stepResult.identifier isEqualToString:@"imageCaptureStep"]) {
            for (ORKResult* imageStepResult in((ORKStepResult*)stepResult).results){
                if([imageStepResult isKindOfClass:[ORKFileResult class]]) {
                    ORKFileResult* fileResult = (ORKFileResult*) imageStepResult;
                    NSURL* fileURL = fileResult.fileURL;
                    imageData = [[NSData alloc] initWithContentsOfURL:fileURL];
                }
            }
        }
    }
    NSArray *labelArray = @[@"Dermal benign", @"Dermal malignant", @"Epidermal benign", @"Epidermal malignant", @"Genodermatosis", @"Inflammatory", @"Lymphoma", @"Not skin", @"Pigmented benign", @"Pigmented malignant"];
    
    if (imageData != nil) {
        [GRPCCall useInsecureConnectionsForHost:kHostAddress];
        
        InceptionService *inceptionService = [[InceptionService alloc] initWithHost:kHostAddress];
        
        InceptionRequest *inceptionRequest = [InceptionRequest message];
        inceptionRequest.jpegEncoded = imageData;
        [inceptionService classifyWithRequest:inceptionRequest handler:
         ^(InceptionResponse *response, NSError *error) {
             
             if (response) {
                 NSLog(@"%@", @"Response");
                 NSLog(@"%@", response);
                 NSString* classLabel = labelArray[[response.classesArray valueAtIndex:0]];
                 NSLog(@"%@", classLabel);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Top skin result!"
                                                        message:classLabel
                                                        delegate:self
                                                        cancelButtonTitle:@"OK!"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
                 // Then, dismiss the task view controller.
                 [self dismissViewControllerAnimated:YES completion:nil];
             } else {t
                 NSLog(@"%@", @"Error");
                 NSLog(@"%@", error);
                 // Then, dismiss the task view controller.
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }];
    }

    
}



@end
