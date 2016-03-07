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
    var client = MSClient?()

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
        taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String, isDirectory: true)
        presentViewController(taskViewController, animated: true, completion: nil)
    }
}


extension ViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
        
        // On form completion, send the results to a database
        let results = []
        if let stepResults = taskViewController.result.results as? [ORKStepResult] {
            // TODO: clean up; consider not hardcoding
            for stepResult in stepResults {
                let stepIdentifier = stepResult.identifier
                if stepIdentifier == "ImageCaptureStep" {
                    print(stepIdentifier)
                    print(stepResult.results)
                    results[stepIdentifier]
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
        
        // Send to an azure database
        self.client = MSClient(
            applicationURLString:"https://thrunresearch.azure-mobile.net/",
            applicationKey:"YgzTPXIjkRWuXbkmaczgleMufrWqWy99"
        )
        
        let item = ["text":"Awesome item"]
        let itemTable = self.client!.tableWithName("Item")
        itemTable.insert(item) {
            (insertedItem, error) in
            if error != nil {
                print("Error" + error.description);
            } else {
                print(insertedItem["id"])
            }
        }
    }
    
}
