//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Derek Kim on 2023-04-23.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Choose",
            bottomText: "your tip")
        return view
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.fifteenPercentButton.rawValue
        button.tapPublisher.flatMap({
            Just(TipChoice.fifteenPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var eighteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .eighteenPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.eighteenPercentButton.rawValue
        button.tapPublisher.flatMap({
            Just(TipChoice.eighteenPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.twentyPercentButton.rawValue
        button.tapPublisher.flatMap({
            Just(TipChoice.twentyPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.customTipButton.rawValue
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8)
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancellables)
        return button
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            fifteenPercentTipButton,
            eighteenPercentTipButton,
            twentyPercentTipButton
        ])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let tipSubject: CurrentValueSubject<TipChoice, Never> = .init(.none)
    var valuePublisher: AnyPublisher<TipChoice, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        tipSubject.send(.none)
    }
    
    private func layout() {
        [headerView, buttonVStackView].forEach(addSubview(_:))
        
        buttonVStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }
    
    private func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(
                title: "Enter Custom Tip",
                message: nil,
                preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Generous tip is appreciated!"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    guard let text = controller.textFields?.first?.text,
                          let value = Int(text) else { return }
                    self?.tipSubject.send(.Custom(value: value))
                }
            [okAction, cancelAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alertController, animated: true)
    }
    
    private func observe() {
        tipSubject.sink { [unowned self] tip in
            resetView()
            switch tip {
            case .none:
                break
            case .fifteenPercent:
                fifteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .eighteenPercent:
                eighteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPercentTipButton.backgroundColor = ThemeColor.secondary
            case .Custom(let value):
                customTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(
                    string: "$\(value)",
                    attributes: [
                        .font: ThemeFont.bold(ofSize: 20)
                    ])
                text.addAttributes([
                    .font: ThemeFont.bold(ofSize: 14)
                ], range: NSMakeRange(0, 1))
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    private func resetView() {
        [fifteenPercentTipButton,
         eighteenPercentTipButton,
         twentyPercentTipButton,
         customTipButton].forEach{
            $0.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(ofSize: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    private func buildTipButton(tip: TipChoice) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(ofSize: 20),
                .foregroundColor: UIColor.white
            ])
        text.addAttributes([
            .font: ThemeFont.demibold(ofSize: 14)
        ], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
}
