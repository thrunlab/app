//
//  ViewController.swift
//  Sentry
//
//  Created by Cathy Wong on 2/7/16.
//  Copyright © 2016 Thrun Lab. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func imageCaptureTaskTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: ImageCaptureTask, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }
}


extension ViewController : ORKTaskViewControllerDelegate {
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        // On form completion, send the results to a database
        if let stepResults = taskViewController.result.results as? [ORKStepResult] {
            // TODO: clean up; consider not hardcoding
            for stepResult in stepResults {
                let stepIdentifier = stepResult.identifier
                if stepIdentifier == "ImageCaptureStep" {
                    print(stepIdentifier)
                    print(stepResult.results)
                } else if stepIdentifier == "LesionTopThreeLabelingStep" {
                    print(stepIdentifier)
                    print(stepResult.results)
                } else if stepIdentifier == "BiopsyPatientInformationStep" {
                    print(stepIdentifier)
                    print(stepResult.results)
                }
            }
        } else {
            // no results
            print("No results!")
        }
        
    }
    
    
}
