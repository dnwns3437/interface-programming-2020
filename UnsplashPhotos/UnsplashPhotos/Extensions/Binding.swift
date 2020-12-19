//
//  Binding.swift
//  UnsplashPhotos
//
//  Created by Woojun Park on 2020/12/20.
//

import SwiftUI

public extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
