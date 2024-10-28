//
//  LoadingView.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 27/10/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.blue)
            .scaleEffect(2.0)
    }
}
