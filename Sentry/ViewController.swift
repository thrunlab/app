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
        taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String, isDirectory: true)
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
                    for result in stepResult.results! {
                        if let result = result as? ORKFileResult,
                            let fileUrl = result.fileURL {
                                if let imagedata = NSData(contentsOfURL: fileUrl) {
                                    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                    let client = delegate.client!
                                    if let  datastring = NSString(data:imagedata, encoding:NSASCIIStringEncoding) as? String {
                                        let item2 = ["text":datastring]
                                        print("success")
                                        let itemTable = client.tableWithName("Item2")
                                        itemTable.insert(item2) {
                                            (insertedItem, error) in
                                            if (error != nil) {
                                                print("Error" + error.description);
                                            } else {
                                                print("Item inserted, id: " + (insertedItem["id"] as! String))
                                            }
                                        }
                                    }
                                }
                                
                        }
                    }
                   
                    
                } else if stepIdentifier == "LesionTopThreeLabelingStep" {
                    print(stepIdentifier)
                    print(stepResult)
                } else if stepIdentifier == "BiopsyPatientInformationStep" {
                    print(stepIdentifier)
                    print(stepResult)
                }
            }
            
            
        
            
            
            
        } else {
            // no results
            print("No results!")
        }
        
    }
    
}
