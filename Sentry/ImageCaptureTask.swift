//
//  ImageCaptureTask.swift
//  Sentry
//
//  Created by Cathy Wong on 2/7/16.
//  Copyright © 2016 Thrun Lab. All rights reserved.
//

import Foundation
import ResearchKit

public var ImageCaptureTask : ORKOrderedTask {
    var steps = [ORKStep]()
    
    // Add the image capture step
    let imageCaptureStep = ORKImageCaptureStep(identifier: "ImageCaptureStep")
    imageCaptureStep.title = "Take a picture of the lesion."
    imageCaptureStep.text = "Center the lesion using the cross hairs. Zoom in as much as possible, but make sure the whole lesion is captured in the photo."
    
    steps += [imageCaptureStep]
    
    // Add the step for the physician to assign a label (TODO: remove this)
    let lesionPhysicianLabelingStepTitle = "What kind of lesion do you believe that this is?"
    let physicianLabelChoices = [
        ORKTextChoice(text: "Melanoma", value: 0),
        ORKTextChoice(text: "Basal Cell Carcinoma", value: 1),
        ORKTextChoice(text: "Vascular Tumor", value: 2),
        ORKTextChoice(text: "Benign Tumor", value: 3),
        ORKTextChoice(text: "Other inflammatory disesase", value: 4)
    ]
    let physicianLabelAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: physicianLabelChoices)
    let lesionLabelingStep = ORKQuestionStep(identifier: "LesionLabelingStep", title: lesionPhysicianLabelingStepTitle, answer: physicianLabelAnswerFormat)
    steps += [lesionLabelingStep]
    
    //TODO: change this to allow for top 3 choices
    let lesionTopThreeLabelingStep = ORKFormStep(identifier: "LesionTopThreeLabelingStep", title: "Clinical Impression", text: "In order, what are your top three labels for what kind of lesion this is? You can choose from the existing labels or type your own.")
    let firstChoiceItem =  ORKFormItem(identifier: "LesionChoiceOneFormItem", text: "First choice label: ", answerFormat: ORKAnswerFormat.textAnswerFormat());
    firstChoiceItem.placeholder = "Example: Melanoma of skin"
    
    let secondChoiceItem =  ORKFormItem(identifier: "LesionChoiceTwoFormItem", text: "Second choice label: ", answerFormat: ORKAnswerFormat.textAnswerFormat());
    secondChoiceItem.placeholder = "Example: Melanoma of skin"
    
    let thirdChoiceItem =  ORKFormItem(identifier: "LesionChoiceThreeFormItem", text: "Third choice label: ", answerFormat: ORKAnswerFormat.textAnswerFormat());
    thirdChoiceItem.placeholder = "Example: Melanoma of skin"
    
    lesionTopThreeLabelingStep.formItems = [
        firstChoiceItem,
        secondChoiceItem,
        thirdChoiceItem
    ]

    steps += [lesionTopThreeLabelingStep]
    

    let biopsyAndPatientInformationStep = ORKFormStep(identifier: "BiopsyPatientInformationStep", title: "Biopsy Date and Patient Identifier", text: "Please complete all sections")
    biopsyAndPatientInformationStep.formItems = [
        ORKFormItem(identifier: "BiopsyDateFormItem", text: "Biopsy date: ", answerFormat: ORKAnswerFormat.dateAnswerFormatWithDefaultDate(nil, minimumDate: nil, maximumDate: nil, calendar: nil)),
        ORKFormItem(identifier: "BiopsyLocationFormItem", text: "Biopsy location: ", answerFormat: ORKAnswerFormat.textAnswerFormat()),
        ORKFormItem(identifier: "PatientIdentifierFormItem", text: "Patient identifier number: ", answerFormat: ORKAnswerFormat.textAnswerFormat())
    ]
    
    steps += [biopsyAndPatientInformationStep]
  
    // Add a summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank you!"
    summaryStep.text = "The data has been submitted."
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "ImageCaptureTask", steps: steps)
}