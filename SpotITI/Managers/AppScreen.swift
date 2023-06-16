//
//  AppScreen.swift
//  SpotITI
//
//  Created by Alessandro Bortoluzzi on 14/06/23.
//

import SwiftUI

class AppScreen: ObservableObject {
    
    // Sheet dimension management
    @Published var currentView: ViewType = .home
    @Published var selectedDetent: PresentationDetent = .large
    @Published var presentationDetents: Set<PresentationDetent> = []
    
    /// Adjusts the size of the view sheet to match the size requirements of the current view.
    ///
    /// This method is used to set the current view to a specified view type, and adjusts the size of the sheet
    /// to fit that view type. The size is defined by the detent associated with the specified view type.
    ///
    /// - Parameter view: The view type that should be set as the current view.
    func setCurrentView(view: ViewType) {
        let viewToDetents: [ViewType: PresentationDetent] = [
            .home: .large,
            .navigationPreview: .fraction(0.35),
            .navigation: .fraction(0.2)
        ]
        
        guard let detent = viewToDetents[view] else { return }
        
        presentationDetents = [.large, .fraction(0.35), .fraction(0.2)]
        currentView = view
        selectedDetent = detent
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presentationDetents = [detent]
        }
    }
    
}
