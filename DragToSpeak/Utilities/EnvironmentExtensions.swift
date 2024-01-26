//
//  EnvironmentExtensions.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//

import SwiftUI

struct DeviceOrientationKey: EnvironmentKey {
    static let defaultValue: UIDeviceOrientation = UIDevice.current.orientation
}

extension EnvironmentValues {
    var deviceOrientation: UIDeviceOrientation {
        get { self[DeviceOrientationKey.self] }
        set { self[DeviceOrientationKey.self] = newValue }
    }
}
