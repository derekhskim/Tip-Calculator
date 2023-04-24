//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by Derek Kim on 2023-04-24.
//

import Foundation
import Combine

class CalculatorVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<TipChoice, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
        let resetCalculatorPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let audioPlayerService: AudioPlayerService
    
    init(audioPlayerService: AudioPlayerService = DefaultAudioPlayer()) {
        self.audioPlayerService = audioPlayerService
    }
    
    func transform(input: Input) -> Output {
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher).flatMap { [unowned self] (bill, tip, split) in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                let result = Result(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resultCalculatorPublisher = input
            .logoViewTapPublisher
            .handleEvents(receiveOutput: { [unowned self] in
            audioPlayerService.playSound()
        }).flatMap {
            return Just(())
        }.eraseToAnyPublisher()
        
        return Output(updateViewPublisher: updateViewPublisher, resetCalculatorPublisher: resultCalculatorPublisher)
    }
    
    private func getTipAmount(bill: Double, tip: TipChoice) -> Double {
        switch tip {
        case .none:
            return 0
        case .fifteenPercent:
            return bill * 0.15
        case .eighteenPercent:
            return bill * 0.18
        case .twentyPercent:
            return bill * 0.2
        case .Custom(let value):
            return Double(value)
        }
    }
    
}
