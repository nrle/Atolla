//
//  ItemImage.swift
//  Music
//
//  Created by Rasmus Krämer on 06.09.23.
//

import SwiftUI
import NukeUI
import AmpFinKit
import UIKit

internal struct DominantColor {
    let color: Color
}

internal enum RFKVisuals {
    static func extractDominantColors(_ maximumCount: Int, image: UIImage) async throws -> [DominantColor] {
        guard let cgImage = image.cgImage else {
            return []
        }

        let width = min(cgImage.width, 40)
        let height = min(cgImage.height, 40)
        guard width > 0, height > 0,
              let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              ) else {
            return []
        }

        context.interpolationQuality = .low
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else {
            return []
        }

        let sampleCount = min(maximumCount, 16)
        let sampleStride = max(1, (width * height) / max(1, sampleCount))
        var colors: [DominantColor] = []

        for pixel in Swift.stride(from: 0, to: width * height, by: sampleStride) {
            let offset = pixel * 4
            let alpha = Double(data[offset + 3]) / 255
            guard alpha > 0.2 else {
                continue
            }

            colors.append(.init(color: Color(
                red: Double(data[offset]) / 255,
                green: Double(data[offset + 1]) / 255,
                blue: Double(data[offset + 2]) / 255,
                opacity: alpha
            )))
        }

        return colors
    }

    static func brightnessExtremeFilter(_ colors: [Color], threshold: Double = 0.15) -> [Color] {
        colors.filter { color in
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: nil)
            let brightness = (Double(red) + Double(green) + Double(blue)) / 3
            return brightness > threshold && brightness < 1 - threshold
        }
    }

    static func determineMostSaturated(_ colors: [Color]) -> Color? {
        colors.max { lhs, rhs in
            saturation(of: lhs) < saturation(of: rhs)
        }
    }

    private static func saturation(of color: Color) -> CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return saturation
    }
}

internal struct ItemImage: View {
    @Environment(\.redactionReasons) private var redactionReasons
    
    let cover: Cover?
    var cornerRadius: CGFloat? = nil
    var priority: ImageRequest.Priority = .normal
    
    private var request: ImageRequest? {
        guard let url = cover?.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        for header in JellyfinClient.shared.customHTTPHeaders {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return .init(urlRequest: urlRequest, priority: priority)
    }
    
    var body: some View {
        GeometryReader { proxy in
            let cornerRadius: CGFloat = cornerRadius ?? proxy.size.width > 140 ? 8 : 6
            
            LazyImage(request: request) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .clipped()
                } else {
                    ZStack {
                        if !redactionReasons.contains(.placeholder) {
                            Image(systemName: "music.note")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 40)
                                .foregroundStyle(.gray.opacity(0.5))
                                .padding(12)
                                .opacity(redactionReasons.isEmpty ? 1 : 0)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .background(.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
                    .contentShape(.hoverMenuInteraction, .rect(cornerRadius: cornerRadius, style: .continuous))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .contentShape(.hoverMenuInteraction, .rect(cornerRadius: cornerRadius))
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity).aspectRatio(contentMode: .fit)
    }
}

#Preview {
    ItemImage(cover: nil)
}

#Preview {
    ItemImage(cover: nil)
        .redacted(reason: .placeholder)
}

#Preview {
    ItemImage(cover: .fixture)
}
