//
//  RuntimePropertiesProvidingMock.swift
//  PolkadotVaultTests
//
//  Created by Krzysztof Rodak on 29/08/2022.
//

import Foundation
@testable import PolkadotVault

final class RuntimePropertiesProvidingMock: RuntimePropertiesProviding {
    var isInDevelopmentMode: Bool = false
}
