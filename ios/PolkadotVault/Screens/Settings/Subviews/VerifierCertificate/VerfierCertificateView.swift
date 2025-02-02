//
//  VerfierCertificateView.swift
//  Polkadot Vault
//
//  Created by Krzysztof Rodak on 12/12/2022.
//

import SwiftUI

struct VerfierCertificateView: View {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var navigation: NavigationCoordinator
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBarView(
                viewModel: NavigationBarViewModel(
                    title: Localizable.VerifierCertificate.Label.title.string,
                    leftButtons: [.init(
                        type: .arrow,
                        action: viewModel.onBackTap
                    )],
                    rightButtons: [.init(type: .empty)]
                )
            )
            if let content = viewModel.content {
                VStack {
                    VStack(spacing: Spacing.small) {
                        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                            Localizable.Transaction.Verifier.Label.key.text
                                .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                            Text(content.publicKey)
                                .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            HStack {
                                Localizable.Transaction.Verifier.Label.crypto.text
                                    .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                                Spacer()
                                Text(content.encryption)
                                    .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                            }
                        }
                    }
                    .padding(Spacing.medium)
                }
                .containerBackground()
                .padding(.bottom, Spacing.extraSmall)
                .padding(.horizontal, Spacing.extraSmall)
                HStack {
                    Text(Localizable.VerifierCertificate.Action.remove.string)
                        .font(PrimaryFont.titleS.font)
                        .foregroundColor(Asset.accentRed400.swiftUIColor)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.onRemoveTap()
                }
                .frame(height: Heights.verifierCertificateActionHeight)
                .padding(.horizontal, Spacing.large)
            }
            Spacer()
        }
        .background(Asset.backgroundPrimary.swiftUIColor)
        .fullScreenCover(isPresented: $viewModel.isPresentingRemoveConfirmation) {
            VerticalActionsBottomModal(
                viewModel: .removeGeneralVerifier,
                mainAction: viewModel.onRemoveConfirmationTap(),
                isShowingBottomAlert: $viewModel.isPresentingRemoveConfirmation
            )
            .clearModalBackground()
        }
        .onAppear {
            viewModel.use(navigation: navigation)
            viewModel.use(appState: appState)
        }
    }
}

extension VerfierCertificateView {
    final class ViewModel: ObservableObject {
        @Published var isPresentingRemoveConfirmation = false
        @Published var content: MVerifierDetails?
        @Binding var isPresented: Bool

        private let onboardingMediator: OnboardingMediator
        private weak var appState: AppState!
        private weak var navigation: NavigationCoordinator!

        init(
            isPresented: Binding<Bool>,
            onboardingMediator: OnboardingMediator = ServiceLocator.onboardingMediator
        ) {
            _isPresented = isPresented
            self.onboardingMediator = onboardingMediator
        }

        func use(navigation: NavigationCoordinator) {
            self.navigation = navigation
        }

        func use(appState: AppState) {
            self.appState = appState
            content = appState.userData.verifierDetails
        }

        func onBackTap() {
            isPresented = false
            appState.userData.verifierDetails = nil
        }

        func onRemoveTap() {
            isPresentingRemoveConfirmation = true
        }

        func onRemoveConfirmationTap() {
            onboardingMediator.onboard(verifierRemoved: true)
            navigation.perform(navigation: .init(action: .start))
        }
    }
}

#if DEBUG
    struct VerfierCertificateView_Previews: PreviewProvider {
        static var previews: some View {
            VerfierCertificateView(viewModel: .init(isPresented: .constant(true)))
        }
    }
#endif
