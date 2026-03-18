//
//  ConfettiView.swift
//  Doomstop
//

import SwiftUI
import UIKit

// MARK: - Confetti UIView
class ConfettiUIView: UIView {
    private var emitter: CAEmitterLayer?

    func startConfetti() {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: bounds.width, height: 1)
        emitter.emitterCells = makeCells()
        layer.addSublayer(emitter)
        self.emitter = emitter

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.stopConfetti()
        }
    }

    func stopConfetti() {
        emitter?.birthRate = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.emitter?.removeFromSuperlayer()
            self?.emitter = nil
        }
    }

    private func makeCells() -> [CAEmitterCell] {
        let colors: [UIColor] = [
            UIColor(red: 0.957, green: 0.639, blue: 0.251, alpha: 1), // #F4A340
            UIColor(red: 0.110, green: 0.110, blue: 0.110, alpha: 1), // #1C1C1C
            UIColor(red: 0.992, green: 0.980, blue: 0.957, alpha: 1), // #FDFAF4
            UIColor(red: 0.310, green: 0.620, blue: 0.416, alpha: 1), // #4f9e6a
        ]

        let shapes = ["square", "circle"]

        return colors.flatMap { color -> [CAEmitterCell] in
            shapes.map { shape in
                let cell = CAEmitterCell()
                cell.contents = makeParticleImage(color: color, shape: shape)?.cgImage
                cell.birthRate = 6
                cell.lifetime = 5
                cell.velocity = CGFloat.random(in: 200...400)
                cell.velocityRange = 80
                cell.emissionLongitude = .pi
                cell.emissionRange = .pi / 5
                cell.spin = CGFloat.random(in: -4...4)
                cell.spinRange = 3
                cell.scale = CGFloat.random(in: 0.3...0.6)
                cell.scaleRange = 0.2
                cell.alphaSpeed = -0.15
                return cell
            }
        }
    }

    private func makeParticleImage(color: UIColor, shape: String) -> UIImage? {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.setFillColor(color.cgColor)
        if shape == "circle" {
            ctx.fillEllipse(in: CGRect(origin: .zero, size: size))
        } else {
            ctx.fill(CGRect(origin: .zero, size: size))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - SwiftUI Wrapper
struct ConfettiView: UIViewRepresentable {
    @Binding var isActive: Bool

    func makeUIView(context: Context) -> ConfettiUIView {
        ConfettiUIView()
    }

    func updateUIView(_ uiView: ConfettiUIView, context: Context) {
        if isActive {
            uiView.startConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isActive = false
            }
        }
    }
}