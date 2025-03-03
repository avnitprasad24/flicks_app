//  OnboardingViewControllerTests.swift
//  flicks_appTests
//
//  Created by Av on 3/2/25.


// working on testing app stuff


import XCTest
@testable import flicks_app
import UIKit

class MockOnboardingViewModel: OnboardingViewModel {
    var currentStepValue: Int = 0
    var isCompleteValue: Bool = false
    var totalStepsValue: Int = 3
    
    override var currentStep: Int {
        get { currentStepValue }
        set { currentStepValue = newValue }
    }
    
    override var isComplete: Bool {
        get { isCompleteValue }
        set { isCompleteValue = newValue }
    }
    
    override var totalSteps: Int {
        totalStepsValue
    }
    
    override func advanceStep() {
        if currentStepValue < totalStepsValue - 1 {
            currentStepValue += 1
        } else {
            isCompleteValue = true
        }
    }
    
    override func recedeStep() {
        if currentStepValue > 0 {
            currentStepValue -= 1
        }
    }
}

class OnboardingViewControllerTests: XCTestCase {
    var viewController: OnboardingViewController!
    var mockViewModel: MockOnboardingViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockOnboardingViewModel()
        viewController = OnboardingViewController(viewModel: mockViewModel)
        viewController.loadView()
        viewController.viewDidLoad()
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    // MARK: - Setup Tests
    func testViewControllerSetup() {
        XCTAssertNotNil(viewController.progressView, "Progress view should be initialized")
        XCTAssertNotNil(viewController.nextButton, "Next button should be initialized")
        XCTAssertNotNil(viewController.backButton, "Back button should be initialized")
        XCTAssertNotNil(viewController.stepContainer, "Step container should be initialized")
        XCTAssertEqual(viewController.view.backgroundColor, .black, "Background should be black")
    }
    
    // MARK: - State Change Tests
    func testProgressUpdateOnStepChange() {
        let initialProgress = viewController.progressView.progress
        mockViewModel.currentStep = 1
        XCTAssertGreaterThan(viewController.progressView.progress, initialProgress, "Progress should increase with step change")
    }
    
    func testShowStepOnStepChange() {
        viewController.simulateStepChange(to: 1)
        let stepView = viewController.stepContainer.subviews.first
        XCTAssertNotNil(stepView, "Step view should be added")
        let label = stepView?.subviews.first as? UILabel
        XCTAssertEqual(label?.text, "Step 2 of 3", "Label should reflect step 2")
    }
    
    // MARK: - Navigation Tests
    func testNextStepNavigation() {
        let expectation = XCTestExpectation(description: "Next step advances")
        viewController.nextButton.sendActions(for: .touchUpInside)
        DispatchQueue.main.async {
            XCTAssertEqual(self.mockViewModel.currentStep, 1, "Step should advance to 1")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPreviousStepNavigation() {
        mockViewModel.currentStep = 1
        let expectation = XCTestExpectation(description: "Previous step recedes")
        viewController.backButton.sendActions(for: .touchUpInside)
        DispatchQueue.main.async {
            XCTAssertEqual(self.mockViewModel.currentStep, 0, "Step should recede to 0")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCompleteNavigation() {
        mockViewModel.currentStep = 2 // Last step
        let expectation = XCTestExpectation(description: "Complete navigates to home")
        viewController.nextButton.sendActions(for: .touchUpInside)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.mockViewModel.isComplete, "Onboarding should be complete")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Animation Tests
    func testAnimationLoop() {
        let expectation = XCTestExpectation(description: "Animation loop updates opacity")
        let initialOpacity = viewController.currentStepView?.layer.opacity
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let newOpacity = self.viewController.currentStepView?.layer.opacity
            XCTAssertNotEqual(newOpacity, initialOpacity, "Opacity should change with animation")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    // MARK: - Accessibility Tests
    func testAccessibilityLabels() {
        XCTAssertEqual(viewController.progressView.accessibilityLabel, "Onboarding Progress", "Progress view should have correct label")
        XCTAssertEqual(viewController.nextButton.accessibilityLabel, "Next Step", "Next button should have correct label")
        XCTAssertEqual(viewController.backButton.accessibilityLabel, "Previous Step", "Back button should have correct label")
        XCTAssertTrue(viewController.progressView.isAccessibilityElement, "Progress view should be accessible")
        XCTAssertTrue(viewController.nextButton.isAccessibilityElement, "Next button should be accessible")
        XCTAssertTrue(viewController.backButton.isAccessibilityElement, "Back button should be accessible")
    }
    
    // MARK: - Performance Test
    func testViewControllerPerformance() {
        measure(metrics: [XCTClockMetric()]) {
            let _ = OnboardingViewController(viewModel: MockOnboardingViewModel())
        }
    }
}
