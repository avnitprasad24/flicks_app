//  OnboardingViewController.swift
//  flicks_app
//
//  Created by Av on 3/2/25.


// working on onboarding . kind of just animation stuff


import UIKit
import Combine

class OnboardingViewController: UIViewController {
    private let viewModel: OnboardingViewModel
    private var cancellables = Set<AnyCancellable>()
    private let stepContainer = UIView()
    private let progressView = UIProgressView()
    private let nextButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    private var currentStepView: UIView?
    private var displayLink: CADisplayLink?
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        startAnimationLoop()
        showStep(0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        progressView.progressTintColor = .white
        progressView.trackTintColor = .gray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        backButton.setTitle("Back", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(previousStep), for: .touchUpInside)
        
        stepContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progressView)
        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(stepContainer)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 80),
            
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            
            stepContainer.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            stepContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stepContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stepContainer.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20)
        ])
        
        // Accessibility
        progressView.isAccessibilityElement = true
        progressView.accessibilityLabel = "Onboarding Progress"
        nextButton.isAccessibilityElement = true
        nextButton.accessibilityLabel = "Next Step"
        backButton.isAccessibilityElement = true
        backButton.accessibilityLabel = "Previous Step"
    }
    
    private func bindViewModel() {
        viewModel.$currentStep
            .sink { [weak self] step in
                self?.updateProgress(step)
                self?.showStep(step)
            }
            .store(in: &cancellables)
        
        viewModel.$isComplete
            .sink { [weak self] isComplete in
                if isComplete {
                    self?.navigateToHome()
                }
            }
            .store(in: &cancellables)
    }
    
    private func startAnimationLoop() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimations))
        displayLink?.preferredFramesPerSecond = 60
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateAnimations() {
        // Simulate animation (e.g., fade or slide for step transitions)
        currentStepView?.layer.opacity = Float(sin(CACurrentMediaTime()))
    }
    
    private func updateProgress(_ step: Int) {
        let progress = Float(step + 1) / Float(viewModel.totalSteps)
        UIView.animate(withDuration: 0.3) {
            self.progressView.progress = progress
        }
    }
    
    private func showStep(_ step: Int) {
        currentStepView?.removeFromSuperview()
        let stepView = createStepView(for: step)
        stepContainer.addSubview(stepView)
        stepView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepView.topAnchor.constraint(equalTo: stepContainer.topAnchor),
            stepView.leadingAnchor.constraint(equalTo: stepContainer.leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: stepContainer.trailingAnchor),
            stepView.bottomAnchor.constraint(equalTo: stepContainer.bottomAnchor)
        ])
        currentStepView = stepView
    }
    
    private func createStepView(for step: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray
        let label = UILabel()
        label.text = "Step \(step + 1) of \(viewModel.totalSteps)"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }
    
    @objc private func nextStep() {
        viewModel.advanceStep()
    }
    
    @objc private func previousStep() {
        viewModel.recedeStep()
    }
    
    private func navigateToHome() {
        let homeVC = HomeFeedViewController() // Placeholder; replace with actual navigation
        homeVC.modalTransitionStyle = .crossDissolve
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }
}

// Extension for testing (to be moved to test target later)
extension OnboardingViewController {
    func simulateStepChange(to step: Int) {
        showStep(step)
    }
}
