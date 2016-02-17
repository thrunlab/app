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
    
    // Add the step for the physician to assign a label
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
    
    // TODO: add a form step to document the biopsy date, location, and patient identifier
    let biopsyAndPatientInformationStep = ORKFormStep(identifier: "BiopsyPatientInformationStep", title: "Biopsy Date and Patient Identifier", text: "Please complete all sections")
    biopsyAndPatientInformationStep.formItems = [
        ORKFormItem(identifier: "BiopsyDateFormItem", text: "Biopsy date: ", answerFormat: ORKAnswerFormat.dateAnswerFormatWithDefaultDate(nil, minimumDate: nil, maximumDate: nil, calendar: nil)),
        ORKFormItem(identifier: "BiopsyLocationFormItem", text: "Biopsy location: ", answerFormat: ORKAnswerFormat.textAnswerFormat()),
        ORKFormItem(identifier: "PatientIdentifierFormItem", text: "Patient identifier: ", answerFormat: ORKAnswerFormat.textAnswerFormat())
    ]
    
    steps += [biopsyAndPatientInformationStep]
  
    // Add a summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank you!"
    summaryStep.text = "The data has been submitted."
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "ImageCaptureTask", steps: steps)
}