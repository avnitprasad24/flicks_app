//  LoadingViewController.swift
//  flicks_app
//
//  Created by Av on 3/2/25.


/*

import UIKit

class LoadingViewController: UIViewController {
    private let logoImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var fadeAnimation: CABasicAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAnimations()
        performInitialLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        logoImageView.image = UIImage(named: "flicks1") // Matches your asset name
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(logoImageView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            logoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 256),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20)
        ])
        
        // Accessibility
        logoImageView.isAccessibilityElement = true
        logoImageView.accessibilityLabel = "Flicks Logo"
        activityIndicator.isAccessibilityElement = true
        activityIndicator.accessibilityLabel = "Loading Indicator"
    }
    
    private func startAnimations() {
        // Fade animation for logo
        fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.3
        fadeAnimation.duration = 1.0
        fadeAnimation.autoreverses = true
        fadeAnimation.repeatCount = .infinity
        logoImageView.layer.add(fadeAnimation, forKey: "fadeAnimation")
        
        // Start activity indicator
        activityIndicator.startAnimating()
    }
    
    private func performInitialLoad() {
        // Simulate app initialization (e.g., API calls, data loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.transitionToMainScreen()
        }
    }
    
    private func transitionToMainScreen() {
        activityIndicator.stopAnimating()
        logoImageView.layer.removeAnimation(forKey: "fadeAnimation")
        
        // Transition to Onboarding screen
        let onboardingVC = OnboardingViewController() // Should now resolve
        onboardingVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        onboardingVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }
}



*/
