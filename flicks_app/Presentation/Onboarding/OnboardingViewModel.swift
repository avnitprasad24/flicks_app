//
//  OnboardingViewModel.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//


//  OnboardingViewModel.swift
//  flicks_app
//
//  Created by Av on 3/2/25.



import Foundation

class OnboardingViewModel {
    private let useCase: SetupProfileUseCase
    private var state: OnboardingState = .initial
    var onStateChanged: (() -> Void)?
    
    init(useCase: SetupProfileUseCase) {
        self.useCase = useCase
    }
    
    enum OnboardingState {
        case initial
        case nameBio(String, String?)
        case musicPermission(String?)
        case songSelection
        case photoUpload
        case completed
    }
    
    var currentState: OnboardingState {
        get { return state }
        set { state = newValue; onStateChanged?() }
    }
    
    func loadStep(_ stepIndex: Int) {
        switch stepIndex {
        case 0: currentState = .nameBio("", nil)
        case 1: currentState = .musicPermission(nil)
        case 2: currentState = .songSelection
        case 3: currentState = .photoUpload
        default: currentState = .completed
        }
    }
    
    func selectMusicService(_ service: String) {
        if case .musicPermission = currentState {
            currentState = .musicPermission(service)
        }
    }
    
    func submitNameBio(name: String, username: String, bio: String?) async {
        do {
            try await useCase.setupProfile(name: name, username: username, bio: bio, musicService: state.musicService)
            currentState = .musicPermission(state.musicService)
        } catch {
            print("Validation failed: \(error.localizedDescription)")
        }
    }
    
    var musicService: String? {
        if case .musicPermission(let service) = state { return service }
        return nil
    }
}

extension OnboardingViewModel {
    func validateName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespaces).isEmpty && name.count <= 50
    }
    
    func validateUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return predicate.evaluate(with: username)
    }
}
