//
//  QuestionTask.swift
//  MOYO
//
//  Created by Whitney H on 9/5/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation
import ResearchKit


//MOOD SURVEY
public var QuestionTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
    
    let anxiousAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let nameQuestionStepTitle = "Anxious"
    let anxiousQuestionStep = ORKQuestionStep(identifier: "AnxiousStep", title: nameQuestionStepTitle, question: "Please rate how the following words describe your mood today:" ,answer: anxiousAnswerFormat)
  //  let anxiousQuestionStep = ORKQuestionStep(identifier: "AnxiousStep", title: nameQuestionStepTitle, answer: anxiousAnswerFormat)
    anxiousQuestionStep.title = "Mood Survey"
    anxiousQuestionStep.text = "Please rate how the following words describe your mood today:"
    steps += [anxiousQuestionStep]
    
    let elatedAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let elatedQuestionStepTitle = "Elated"
    let elatedQuestionStep = ORKQuestionStep(identifier: "ElatedStep", title: elatedQuestionStepTitle, answer: elatedAnswerFormat)
    steps += [elatedQuestionStep]
    
    let sadAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let sadQuestionStepTitle = "Sad"
    let sadQuestionStep = ORKQuestionStep(identifier: "SadStep", title: sadQuestionStepTitle, answer: sadAnswerFormat)
    steps += [sadQuestionStep]
    
    let angryAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let angryQuestionStepTitle = "Angry"
    let angryQuestionStep = ORKQuestionStep(identifier: "AngryStep", title: angryQuestionStepTitle, answer: angryAnswerFormat)
    steps += [angryQuestionStep]
    
    let irritableAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let irritableQuestionStepTitle = "Irritable"
    let irritableQuestionStep = ORKQuestionStep(identifier: "IrritableStep", title: irritableQuestionStepTitle, answer: irritableAnswerFormat)
    steps += [irritableQuestionStep]
    
    let energeticAnswerFormat = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 1, defaultValue: 5, step: 1, vertical: false, maximumValueDescription: "low", minimumValueDescription: "high")
    let energeticQuestionStepTitle = "Energetic"
    let energeticQuestionStep = ORKQuestionStep(identifier: "EnergeticStep", title: energeticQuestionStepTitle, answer: energeticAnswerFormat)
    steps += [energeticQuestionStep]
    
    
    let stressStepTitle = "What was your main cause of stress today?"
    let textChoices = [
        ORKTextChoice(text: "Health", value: "Health" as NSString),
        ORKTextChoice(text: "Work/Study", value: "Work/Study" as NSString),
        ORKTextChoice(text: "Money", value: "Money" as NSString),
        ORKTextChoice(text: "Relationship", value: "Relationship" as NSString),
        ORKTextChoice(text: "Family", value: "Family" as NSString),
        ORKTextChoice(text: "Other", value: "Other" as NSString)
    ]
    
    let stressAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let stressStep = ORKQuestionStep(identifier: "StressStep", title: stressStepTitle, answer: stressAnswerFormat)
    steps += [stressStep]
    
    
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    
    
}

//PHQ9 SURVEY
//UPLOAD NUMERICAL SCORE
public var PHQ9SurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "PHQ-9 Questionnaire"
        instructionStep.text = "Over the last two weeks, how often have you been bothered by any of the following problems?"
    steps += [instructionStep]
    
    
    let depressionTitleOne = "Little interest or pleasure in doing things?"
    let textChoices = [
        ORKTextChoice(text: "Not at all", value: 0 as NSNumber),
        ORKTextChoice(text: "Several days", value: 1 as NSNumber),
        ORKTextChoice(text: "More than half the days", value: 2 as NSNumber),
        ORKTextChoice(text: "Nearly every day", value: 3 as NSNumber)
    ]
    
    let depressionAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
 //  let depressionStepOne = ORKQuestionStep(identifier: "Little interest or pleasure in doing things?", title: depressionTitleOne, question: "", answer: depressionAnswerFormat)
    let depressionStepOne = ORKQuestionStep(identifier: "Little interest or pleasure in doing things?", title: depressionTitleOne, answer: depressionAnswerFormat)
    depressionStepOne.title = "PHQ-9 Questionnaire"
    depressionStepOne.text = "Over the last two weeks how often have you been bothered by any of the following problems?"
    depressionStepOne.isOptional = false
    steps += [depressionStepOne]
    
    let depressionTitleTwo = "Feeling down or depressed or hopeless?"
    let depressionAnswerFormatTwo: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepTwo = ORKQuestionStep(identifier: "Feeling down or depressed or hopeless?", title: depressionTitleTwo, answer: depressionAnswerFormatTwo)
    depressionStepTwo.isOptional = false
    steps += [depressionStepTwo]
    
    let depressionTitleThree = "Trouble falling or staying asleep or sleeping too much?"
    let depressionAnswerFormatThree: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepThree = ORKQuestionStep(identifier: "Trouble falling or staying asleep or sleeping too much?", title: depressionTitleThree, answer: depressionAnswerFormatThree)
    depressionStepThree.isOptional = false
    steps += [depressionStepThree]
    
    let depressionTitleFour = "Feeling tired or having little energy?"
    let depressionAnswerFormatFour: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepFour = ORKQuestionStep(identifier: "Feeling tired or having little energy?", title: depressionTitleFour, answer: depressionAnswerFormatFour)
    depressionStepFour.isOptional = false
    steps += [depressionStepFour]
    
    let depressionTitleFive = "Poor appetite or overeating?"
    let depressionAnswerFormatFive: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepFive = ORKQuestionStep(identifier: "Poor appetite or overeating?", title: depressionTitleFive, answer: depressionAnswerFormatFive)
    depressionStepFive.isOptional = false
    steps += [depressionStepFive]
    
    let depressionTitleSix = "Feeling bad about yourself or that you are a failure or have let yourself or your family down?"
    let depressionAnswerFormatSix: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepSix = ORKQuestionStep(identifier: "Feeling bad about yourself or that you are a failure or have let yourself or your family down?", title: depressionTitleSix, answer: depressionAnswerFormatSix)
    depressionStepSix.isOptional = false
    steps += [depressionStepSix]
    
    let depressionTitleSeven = "Trouble concentrating on things such as reading the newspaper or watching television?"
    let depressionAnswerFormatSeven: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepSeven = ORKQuestionStep(identifier: "Trouble concentrating on things such as reading the newspaper or watching television?", title: depressionTitleSeven, answer: depressionAnswerFormatSeven)
    depressionStepSeven.isOptional = false
    steps += [depressionStepSeven]
    
    let depressionTitleEight = "Thoughts that you would be better off dead or of hurting yourself in some way?"
    let depressionAnswerFormatEight: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let depressionStepEight = ORKQuestionStep(identifier: "Thoughts that you would be better off dead or of hurting yourself in some way?", title: depressionTitleEight, answer: depressionAnswerFormatEight)
    depressionStepEight.isOptional = false
    steps += [depressionStepEight]
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the questionnaire."
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "PHQ9SurveyTask", steps: steps)
    
}



//GAD-7 SURVEY
//NEED NUMERICAL TOTAL FOR SURVEY UPLOADED
public var GAD7SurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "GAD-7 Questionnaire"
    instructionStep.text = "Over the last two weeks, how often have you been bothered by any of the following problems?"
    steps += [instructionStep]
     

    let anxietyTextChoices = [
        ORKTextChoice(text: "Not at all", value: 0 as NSNumber),
        ORKTextChoice(text: "Several days", value: 1 as NSNumber),
        ORKTextChoice(text: "More than half the days", value: 2 as NSNumber),
        ORKTextChoice(text: "Nearly every day", value: 3 as NSNumber)
    ]
    
    let anxietyTitleOne = "Feeling nervous or anxious or on edge?"
    let anxietyAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep = ORKQuestionStep(identifier: "Feeling nervous or anxious or on edge?", title: anxietyTitleOne, answer: anxietyAnswerFormat)
    anxietyQuestionStep.isOptional = false
    steps += [anxietyQuestionStep]
    
    let anxietyTitleTwo = "Not being able to stop or control worrying?"
    let anxietyAnswerFormat2: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep2 = ORKQuestionStep(identifier: "Not being able to stop or control worrying?", title: anxietyTitleTwo, answer: anxietyAnswerFormat2)
    anxietyQuestionStep2.isOptional = false
    steps += [anxietyQuestionStep2]

    let anxietyTitleThree = "Worrying too much about different things?"
    let anxietyAnswerFormat3: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep3 = ORKQuestionStep(identifier: "Worrying too much about different things?", title: anxietyTitleThree, answer: anxietyAnswerFormat3)
    anxietyQuestionStep3.isOptional = false
    steps += [anxietyQuestionStep3]
    
    let anxietyTitle4 = "Trouble relaxing?"
    let anxietyAnswerFormat4: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep4 = ORKQuestionStep(identifier: "Trouble relaxing?", title: anxietyTitle4, answer: anxietyAnswerFormat4)
    anxietyQuestionStep4.isOptional = false
    steps += [anxietyQuestionStep4]
    
    let anxietyTitle5 = "Being so restless that it is hard to sit still?"
    let anxietyAnswerFormat5: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep5 = ORKQuestionStep(identifier: "Being so restless that it is hard to sit still?", title: anxietyTitle5, answer: anxietyAnswerFormat5)
    anxietyQuestionStep5.isOptional = false
    steps += [anxietyQuestionStep5]
    
    let anxietyTitle6 = "Becoming easily annoyed or irritable?"
    let anxietyAnswerFormat6: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep6 = ORKQuestionStep(identifier: "Becoming easily annoyed or irritable?", title: anxietyTitle6, answer: anxietyAnswerFormat6)
    anxietyQuestionStep6.isOptional = false
    steps += [anxietyQuestionStep6]
    
    let anxietyTitle7 = "Feeling afraid as if something awful might happen?"
    let anxietyAnswerFormat7: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep7 = ORKQuestionStep(identifier: "Feeling afraid as if something awful might happen?", title: anxietyTitle7, answer: anxietyAnswerFormat7)
    anxietyQuestionStep7.isOptional = false
    steps += [anxietyQuestionStep7]

    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the questionnaire."
    steps += [completionStep]

    return ORKOrderedTask(identifier: "GAD7SurveyTask", steps: steps)


}


//GSQ SURVEY

public var GSQSurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "GSQ Questionnaire"
    instructionStep.text = "Please answer the following questions"
    steps += [instructionStep]
     

    let anxietyTextChoices = [
        ORKTextChoice(text: "Not at all", value: 0 as NSNumber),
        ORKTextChoice(text: "Some of the time", value: 1 as NSNumber),
        ORKTextChoice(text: "More than half of the time", value: 2 as NSNumber),
        ORKTextChoice(text: "All of the time", value: 3 as NSNumber)
    ]
    
    
    let anxietyTextChoices1 = [
        ORKTextChoice(text: "0-15 minutes", value: 0 as NSNumber),
        ORKTextChoice(text: "16-30 minutes", value: 1 as NSNumber),
        ORKTextChoice(text: "31-45 minutes", value: 2 as NSNumber),
        ORKTextChoice(text: "46-60 minutes", value: 3 as NSNumber),
        ORKTextChoice(text: "60+ minutes", value: 4 as NSNumber)
    ]
    
    let anxietyTextChoices2 = [
          ORKTextChoice(text: "Very good", value: 0 as NSNumber),
          ORKTextChoice(text: "Good", value: 1 as NSNumber),
          ORKTextChoice(text: "Okay", value: 2 as NSNumber),
          ORKTextChoice(text: "Bad", value: 3 as NSNumber),
          ORKTextChoice(text: "Very bad", value: 4 as NSNumber)
      ]
      
    let anxietyTextChoices3 = [
          ORKTextChoice(text: "Yes", value: 1 as NSNumber),
          ORKTextChoice(text: "No", value: 0 as NSNumber)
      ]
      
    
    let freeTextAnswerFormat = ORKTextAnswerFormat(maximumLength: 500)
    
    
    let anxietyTitleOne = "In the last THREE DAYS, I have taken my medications as scheduled"
    let anxietyAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep = ORKQuestionStep(identifier: "In the last THREE DAYS I have taken my medications as scheduled", title: anxietyTitleOne, answer: anxietyAnswerFormat)
    anxietyQuestionStep.isOptional = false
    steps += [anxietyQuestionStep]
    
    let anxietyTitleTwo = "Today I have heard voices or saw things others cannot"
    let anxietyAnswerFormat2: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep2 = ORKQuestionStep(identifier: "Today I have heard voices or saw things others cannot", title: anxietyTitleTwo, answer: anxietyAnswerFormat2)
    anxietyQuestionStep2.isOptional = false
    steps += [anxietyQuestionStep2]

    let anxietyTitleThree = "Today I have thoughts racing through my head"
    let anxietyAnswerFormat3: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep3 = ORKQuestionStep(identifier: "Today I have thoughts racing through my head", title: anxietyTitleThree, answer: anxietyAnswerFormat3)
    anxietyQuestionStep3.isOptional = false
    steps += [anxietyQuestionStep3]
    
    let anxietyTitle4 = "Today I feel I have special powers"
    let anxietyAnswerFormat4: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep4 = ORKQuestionStep(identifier: "Today I feel I have special powers", title: anxietyTitle4, answer: anxietyAnswerFormat4)
    anxietyQuestionStep4.isOptional = false
    steps += [anxietyQuestionStep4]
    
    let anxietyTitle5 = "Today I feel people are watching me"
    let anxietyAnswerFormat5: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep5 = ORKQuestionStep(identifier: "Today I feel people are watching me", title: anxietyTitle5, answer: anxietyAnswerFormat5)
    anxietyQuestionStep5.isOptional = false
    steps += [anxietyQuestionStep5]
    
    let anxietyTitle6 = "Today I feel people are againt me"
    let anxietyAnswerFormat6: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep6 = ORKQuestionStep(identifier: "Today I feel people are againt me", title: anxietyTitle6, answer: anxietyAnswerFormat6)
    anxietyQuestionStep6.isOptional = false
    steps += [anxietyQuestionStep6]
    
    let anxietyTitle7 = "Today I feel consumed or puzzled"
    let anxietyAnswerFormat7: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
    let anxietyQuestionStep7 = ORKQuestionStep(identifier: "Today I feel consumed or puzzled", title: anxietyTitle7, answer: anxietyAnswerFormat7)
    anxietyQuestionStep7.isOptional = false
    steps += [anxietyQuestionStep7]
    
    let anxietyTitle8 = "Today I feel unable to cope and have difficulty with everyday tasks"
      let anxietyAnswerFormat8: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
      let anxietyQuestionStep8 = ORKQuestionStep(identifier: "Today I feel unable to cope and have difficulty with everyday tasks", title: anxietyTitle8, answer: anxietyAnswerFormat8)
      anxietyQuestionStep8.isOptional = false
      steps += [anxietyQuestionStep8]
    
    let anxietyTitle9 = "In the last THREE DAYS, during the daytime I have gone outside my home"
      let anxietyAnswerFormat9: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
      let anxietyQuestionStep9 = ORKQuestionStep(identifier: "In the last THREE DAYS during the daytime I have gone outside my home", title: anxietyTitle9, answer: anxietyAnswerFormat9)
      anxietyQuestionStep9.isOptional = false
      steps += [anxietyQuestionStep9]
    
    let anxietyTitle10 = "In the last THREE DAYS, I have preferred to spend time alone"
      let anxietyAnswerFormat10: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
      let anxietyQuestionStep10 = ORKQuestionStep(identifier: "In the last THREE DAYS I have preferred to spend time alone", title: anxietyTitle10, answer: anxietyAnswerFormat10)
      anxietyQuestionStep10.isOptional = false
      steps += [anxietyQuestionStep10]
    
    let anxietyTitle11 = "In the last THREE DAYS, I have had arguments with other people"
      let anxietyAnswerFormat11: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
      let anxietyQuestionStep11 = ORKQuestionStep(identifier: "In the last THREE DAYS I have had arguments with other people", title: anxietyTitle11, answer: anxietyAnswerFormat11)
      anxietyQuestionStep11.isOptional = false
      steps += [anxietyQuestionStep11]
    
    let anxietyTitle12 = "In the last THREE DAYS, I have had someone to talk to"
      let anxietyAnswerFormat12: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
      let anxietyQuestionStep12 = ORKQuestionStep(identifier: "In the last THREE DAYS I have had someone to talk to", title: anxietyTitle12, answer: anxietyAnswerFormat12)
      anxietyQuestionStep12.isOptional = false
      steps += [anxietyQuestionStep12]
    
    let anxietyTitle13 = "In the last THREE DAYS, I have felt uneasy with groups of people"
      let anxietyAnswerFormat13: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices)
      let anxietyQuestionStep13 = ORKQuestionStep(identifier: "In the last THREE DAYS I have felt uneasy with groups of people", title: anxietyTitle13, answer: anxietyAnswerFormat13)
      anxietyQuestionStep13.isOptional = false
      steps += [anxietyQuestionStep13]
    
    
    let anxietyTitle14 = "How much exercise have you gotten today?"
        let anxietyAnswerFormat14: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices1)
        let anxietyQuestionStep14 = ORKQuestionStep(identifier: "How much exercise have you gotten today?", title: anxietyTitle14, answer: anxietyAnswerFormat14)
        anxietyQuestionStep14.isOptional = false
        steps += [anxietyQuestionStep14]
    
    let anxietyTitle15 = "How did you feel this week?"
          let anxietyAnswerFormat15: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices2)
          let anxietyQuestionStep15 = ORKQuestionStep(identifier: "How did you feel this week?", title: anxietyTitle15, answer: anxietyAnswerFormat15)
          anxietyQuestionStep15.isOptional = false
          steps += [anxietyQuestionStep15]
    
    let anxietyTitle16 = "Have you been admitted to the hospital for psychiatric reasons?"
           let anxietyAnswerFormat16: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: anxietyTextChoices3)
           let anxietyQuestionStep16 = ORKQuestionStep(identifier: "Have you been admitted to the hospital for psychiatric reasons?", title: anxietyTitle16, answer: anxietyAnswerFormat16)
           anxietyQuestionStep16.isOptional = false
           steps += [anxietyQuestionStep16]
    
    let anxietyTitle17 = "Use this space to enter your thoughts and feeling about this week"
           let anxietyQuestionStep17 = ORKQuestionStep(identifier: "Use this space to enter your thoughts and feeling about this week", title: anxietyTitle17, answer: freeTextAnswerFormat)
           anxietyQuestionStep17.isOptional = false
           steps += [anxietyQuestionStep17]

    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the questionnaire."
    steps += [completionStep]

    return ORKOrderedTask(identifier: "GSQSurveyTask", steps: steps)


}


//MUQ SURVEY

public var MUQSurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "MUQ Questionnaire"
    instructionStep.text = "Please answer the following question"
    steps += [instructionStep]
     

    let medsTextChoices = [
        ORKTextChoice(text: "0", value: 0 as NSNumber),
        ORKTextChoice(text: "Less than half the time", value: 1 as NSNumber),
        ORKTextChoice(text: "More than half of the time", value: 2 as NSNumber),
        ORKTextChoice(text: "All the time", value: 3 as NSNumber)
    ]
    
    let medsTitleOne = "Over the past two weeks, how many times did you forget to take your medication?"
    let medsAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: medsTextChoices)
    let medsQuestionStep = ORKQuestionStep(identifier: "Over the past two weeks how many times did you forget to take your medication?", title: medsTitleOne, answer: medsAnswerFormat)
    medsQuestionStep.isOptional = false
    steps += [medsQuestionStep]
 
  
    

    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the questionnaire."
    steps += [completionStep]

    return ORKOrderedTask(identifier: "MUQSurveyTask", steps: steps)


}

//MOYO MOM SYMPTOMS SURVEY

public var SymptomTask: ORKOrderedTask {
    var steps = [ORKStep]()

    let symptomQuestion = "Blood Pressure Symptoms"

//    //Headache step
    let headacheQuestionStep = ORKFormStep(identifier: "HeadacheStep", title: symptomQuestion, text: nil)

 
    let headacheImage = UIImage(named: "headache")!
    let headacheText = NSLocalizedString("", comment: "")

    let headacheimageChoces = [
               ORKImageChoice(normalImage: headacheImage, selectedImage: headacheImage, text: headacheText, value:headacheText as NSCoding & NSCopying & NSObjectProtocol)
    ]

    let headacheformItemText = NSLocalizedString("A pounding or throbbing pain in your head that does not go away with rest or medications.", comment: "")
    let headacheformItem = ORKFormItem(identifier: String("headacheForm"), text: headacheformItemText, answerFormat: ORKAnswerFormat.choiceAnswerFormat(with: headacheimageChoces))

    let headacheformYesNo = ORKFormItem(identifier: String("headacheYesNo"), text: nil, answerFormat: ORKAnswerFormat.booleanAnswerFormat())
    headacheformYesNo.isOptional = false


    headacheQuestionStep.isOptional = false
    headacheQuestionStep.formItems = [
        headacheformItem, headacheformYesNo]
    steps += [headacheQuestionStep]


   // Vision step
    
    let visionQuestionStep = ORKFormStep(identifier: "VisionStep", title: symptomQuestion, text: nil)
    
    let visionImage = UIImage(named: "visual")!
    let visionText = NSLocalizedString("", comment: "")

    let visionimageChoces = [
               ORKImageChoice(normalImage: visionImage, selectedImage: visionImage, text: visionText, value:headacheText as NSCoding & NSCopying & NSObjectProtocol)
    ]

    let visionformItemText = NSLocalizedString("Seeing spots or flashing lights in front of your eyes, blurry vision, or sensitivity to light", comment: "")
    let visionformItem = ORKFormItem(identifier: String("visionForm"), text: visionformItemText, answerFormat: ORKAnswerFormat.choiceAnswerFormat(with: visionimageChoces))
    
    let visionformYesNo = ORKFormItem(identifier: String("visionYesNo"), text: nil, answerFormat: ORKAnswerFormat.booleanAnswerFormat())
     visionformYesNo.isOptional = false
    
    visionQuestionStep.isOptional = false
    visionQuestionStep.formItems = [
        visionformItem, visionformYesNo]
    steps += [visionQuestionStep]
    
    
   //Pain step
    
   let painQuestionStep = ORKFormStep(identifier: "PainStep", title: symptomQuestion, text: nil)
    
   let painImage = UIImage(named: "side_pain")!
   let painText = NSLocalizedString("", comment: "")

   let painImageChoces = [
              ORKImageChoice(normalImage: painImage, selectedImage: painImage, text: painText, value:painText as NSCoding & NSCopying & NSObjectProtocol)
   ]

   let painformItemText = NSLocalizedString("Pain under the ribs on your right side that may be accompanied by nausea or vomiting.", comment: "")
   let painformItem = ORKFormItem(identifier: String("painForm"), text: painformItemText, answerFormat: ORKAnswerFormat.choiceAnswerFormat(with: painImageChoces))
   let painformYesNo = ORKFormItem(identifier: String("painYesNo"), text: nil, answerFormat: ORKAnswerFormat.booleanAnswerFormat())
    
    painformYesNo.isOptional = false
    painQuestionStep.isOptional = false
    painQuestionStep.formItems = [
        painformItem, painformYesNo]
    steps += [painQuestionStep]

    // Breathing step
    
    let breathingQuestionStep = ORKFormStep(identifier: "BreathingStep", title: symptomQuestion, text: nil)
    
   
   let breathingImage = UIImage(named: "Shortness_of_breath")!
   let breathingText = NSLocalizedString("", comment: "")

   let breathingImageChoces = [
              ORKImageChoice(normalImage: breathingImage, selectedImage: breathingImage, text: breathingText, value:breathingText as NSCoding & NSCopying & NSObjectProtocol)
   ]

   let breathingformItemText = NSLocalizedString("Difficulty breathing or a tightness in your chest.", comment: "")
   let breathingformItem = ORKFormItem(identifier: String("breathForm"), text: breathingformItemText, answerFormat: ORKAnswerFormat.choiceAnswerFormat(with: breathingImageChoces))
   let breathingformYesNo = ORKFormItem(identifier: String("breathingYesNo"), text: nil, answerFormat: ORKAnswerFormat.booleanAnswerFormat())
    breathingformYesNo.isOptional = false
    
    
    breathingQuestionStep.isOptional = false
    breathingQuestionStep.formItems = [
        breathingformItem, breathingformYesNo]
    steps += [breathingQuestionStep]

    
    return ORKOrderedTask(identifier: "SymptomTask", steps: steps)
    
}


//KCCQ12 SURVEY
public var KCCQ12SurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
    let cardioTitleOne = "Showering or Bathing"
    let cardioTextChoices = [
        ORKTextChoice(text: "Extremely limited", value: 1 as NSNumber),
        ORKTextChoice(text: "Quite a bit limited", value: 2 as NSNumber),
        ORKTextChoice(text: "Moderately limited", value: 3 as NSNumber),
        ORKTextChoice(text: "Slightly limited", value: 4 as NSNumber),
        ORKTextChoice(text: "Not at all limited", value: 5 as NSNumber),
        ORKTextChoice(text: "Limited for other reasons/Did not do activity", value: 0 as NSNumber)

    ]


    let cardioAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepOne = ORKQuestionStep(identifier: "Showering or Bathing", title: cardioTitleOne, answer: cardioAnswerFormat)
    cardioStepOne.title = "KCCQ-12 Questionnaire"
    cardioStepOne.text = "Please indicate how much you are limited by heart failure (shortness of breath or fatigue) in your ability to do the following activities over the past 2 weeks."

    steps += [cardioStepOne]

    let cardioTitleTwo = "Walking 1 block on level ground"

    let cardioAnswerFormatTwo: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepTwo = ORKQuestionStep(identifier: "Walking 1 block on level ground", title: cardioTitleTwo, answer: cardioAnswerFormatTwo)
    cardioStepTwo.isOptional = false
    steps += [cardioStepTwo]


    let cardioTitleThree = "Hurrying or jogging as if to catch a bus"

    let cardioAnswerFormatThree: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepThree = ORKQuestionStep(identifier: "Hurrying or jogging as if to catch a bus", title: cardioTitleThree, answer: cardioAnswerFormatThree)
    cardioStepThree.isOptional = false
    steps += [cardioStepThree]



    let cardioTextChoicesTwo = [
        ORKTextChoice(text: "Every morning", value: 1 as NSNumber),
        ORKTextChoice(text: "3 or more times per week but not every day", value: 2 as NSNumber),
        ORKTextChoice(text: "1-2 times per week", value: 3 as NSNumber),
        ORKTextChoice(text: "Less than once a week", value: 4 as NSNumber),
        ORKTextChoice(text: "Never over the past 2 weeks", value: 5 as NSNumber)
    ]
    let cardioTitleFour = "Over the past 2 weeks how many times did you have swelling in your feet ankles or legs when you woke up in the morning?"
    let cardioBodyFour = ""
    let cardioAnswerFormatFour: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesTwo)
    let cardioStepFour = ORKQuestionStep(identifier: "Over the past 2 weeks how many times did you have swelling in your feet ankles or legs when you woke up in the morning?", title: cardioTitleFour, text: cardioBodyFour, answer: cardioAnswerFormatFour)
    cardioStepFour.isOptional = false
    steps += [cardioStepFour]


    let cardioTextChoicesThree = [
        ORKTextChoice(text: "All of the time", value: 1 as NSNumber),
        ORKTextChoice(text: "Several times per day", value: 2 as NSNumber),
        ORKTextChoice(text: "At least once a day", value: 3 as NSNumber),
        ORKTextChoice(text: "3 or more times per week but not every day", value: 4 as NSNumber),
        ORKTextChoice(text: "1-2 times per week", value: 5 as NSNumber),
        ORKTextChoice(text: "Less than once a week", value: 6 as NSNumber),
        ORKTextChoice(text: "Never over the past two weeks", value: 7 as NSNumber)
    ]

    let cardioTitleFive = "Over the past 2 weeks on average how many times has fatigue limited your ability to do what you wanted?"
    let cardioBodyFive = ""
    let cardioAnswerFormatFive: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesThree)
    let cardioStepFive = ORKQuestionStep(identifier: "Over the past 2 weeks on average how many times has fatigue limited your ability to do what you wanted?", title: cardioTitleFive, text: cardioBodyFive, answer: cardioAnswerFormatFive)
    cardioStepFive.isOptional = false
    steps += [cardioStepFive]

    let cardioTitleSix = "Over the past 2 weeks on average how many times has shortness of breath limited your ability to do what you wanted?"
    let cardioBodySix = ""
    let cardioAnswerFormatSix: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesThree)
    let cardioStepSix = ORKQuestionStep(identifier: "Over the past 2 weeks on average how many times has shortness of breath limited your ability to do what you wanted?", title: cardioTitleSix, text: cardioBodySix, answer: cardioAnswerFormatSix)
    cardioStepSix.isOptional = false
    steps += [cardioStepSix]


    let cardioTextChoicesFour = [
        ORKTextChoice(text: "Every night", value: 1 as NSNumber),
        ORKTextChoice(text: "3 or more times per week but not every day", value: 2 as NSNumber),
        ORKTextChoice(text: "1-2 times per week", value: 3 as NSNumber),
        ORKTextChoice(text: "Less than once a week", value: 4 as NSNumber),
        ORKTextChoice(text: "Never over the past 2 weeks", value: 5 as NSNumber)
    ]

    let cardioTitleSeven = "Over the past 2 weeks on average how many times have you been forced to sleep sitting up in a chair or with at least 3 pillows to prop you up because of shortness of breath?"
    let cardioBodySeven = ""
    let cardioAnswerFormatSeven: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesFour)
    let cardioStepSeven = ORKQuestionStep(identifier: "Over the past 2 weeks on average how many times have you been forced to sleep sitting up in a chair or with at least 3 pillows to prop you up because of shortness of breath?", title: cardioTitleSeven, text: cardioBodySeven, answer: cardioAnswerFormatSeven)
    cardioStepSeven.isOptional = false
    steps += [cardioStepSeven]


    let cardioTextChoicesFive = [
        ORKTextChoice(text: "It has extremely limited my enjoyment of life", value: 1 as NSNumber),
        ORKTextChoice(text: "It has limited my enjoyment of life quite a bit", value: 2 as NSNumber),
        ORKTextChoice(text: "It has moderately limited my enjoyment of life", value: 3 as NSNumber),
        ORKTextChoice(text: "It has slightly limited by enjoyment of life", value: 4 as NSNumber),
        ORKTextChoice(text: "It has not limited my enjoyment of life at all", value: 5 as NSNumber)
    ]

    let cardioTitleEight = "Over the past 2 weeks how much has your heart failure limited your enjoyment of life?"
    let cardioBodyEight = ""
    let cardioAnswerFormatEight: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesFive)
    let cardioStepEight = ORKQuestionStep(identifier: "Over the past 2 weeks how much has your heart failure limited your enjoyment of life?", title: cardioTitleEight, text: cardioBodyEight, answer: cardioAnswerFormatEight)
    cardioStepEight.isOptional = false
    steps += [cardioStepEight]


    let cardioTextChoicesSix = [
        ORKTextChoice(text: "Not at all satisfied", value: 1 as NSNumber),
        ORKTextChoice(text: "Mostly dissatisfied", value: 2 as NSNumber),
        ORKTextChoice(text: "Somewhat satisfied", value: 3 as NSNumber),
        ORKTextChoice(text: "Mostly satisfied", value: 4 as NSNumber),
        ORKTextChoice(text: "Completely satisfied", value: 5 as NSNumber)
    ]

    let cardioTitleNine = "If you had to spend the rest of your life with your heart failure the way it is right now how would you feel about this?"
    let cardioBodyNine = ""
    let cardioAnswerFormatNine: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoicesSix)
    let cardioStepNine = ORKQuestionStep(identifier: "If you had to spend the rest of your life with your heart failure the way it is right now how would you feel about this?", title: cardioTitleNine, text: cardioBodyNine, answer: cardioAnswerFormatNine)
    cardioStepNine.isOptional = false
    steps += [cardioStepNine]

    let cardioTitleTen = "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in HOBBIES AND RECREATIONAL activities over the past 2 weeks?"
    //let cardioBodyTen = "Hobbies and recreational activities"
    let cardioAnswerFormatTen: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStepTen = ORKQuestionStep(identifier: "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in HOBBIES AND RECREATIONAL activities over the past 2 weeks?", title: cardioTitleTen, answer: cardioAnswerFormatTen)
    cardioStepTen.isOptional = false
    steps += [cardioStepTen]

    let cardioTitle11 = "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in HOUSEHOLD activities over the past 2 weeks?"
   // let cardioBody11 = "Working or doing household chores"
    let cardioAnswerFormat11: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStep11 = ORKQuestionStep(identifier: "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in HOUSEHOLD activities over the past 2 weeks?", title: cardioTitle11, answer: cardioAnswerFormat11)
    cardioStep11.isOptional = false
    steps += [cardioStep11]

    let cardioTitle12 = "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in VISITING FRIENDS AND FAMILY over the past 2 weeks?"
 //   let cardioBody12 = "Visiting family or friends out of your home"
    let cardioAnswerFormat12: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: cardioTextChoices)
    let cardioStep12 = ORKQuestionStep(identifier: "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in VISITING FRIENDS AND FAMILY over the past 2 weeks?", title: cardioTitle12, answer: cardioAnswerFormat12)
    cardioStep12.isOptional = false
    steps += [cardioStep12]


    //Summary
    let completionStep = ORKCompletionStep(identifier: "SummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the questionnaire."
    steps += [completionStep]

    return ORKOrderedTask(identifier: "KCCQ12SurveyTask", steps: steps)


}


