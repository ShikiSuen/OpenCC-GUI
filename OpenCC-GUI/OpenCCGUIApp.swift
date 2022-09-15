// (c) 2021 and onwards The vChewing Project (MIT-NTL License).
// ====================
// This code is released under the MIT license (SPDX-License-Identifier: MIT)
// ... with NTL restriction stating that:
// No trademark license is granted to use the trade names, trademarks, service
// marks, or product names of Contributor, except as required to fulfill notice
// requirements defined in MIT License.

import OpenCC
import SwiftUI

@main
struct OpenCCGUIApp: App {
  var body: some Scene {
    WindowGroup {
      MainView()
    }
  }
}

var converterS2T = try! ChineseConverter(options: [.traditionalize, .twStandard])
var converterT2S = try! ChineseConverter(options: [.simplify, .twStandard])

struct MainView: View {
  @State var contentCHS: String = ""
  @State var contentCHT: String = ""
  @State var selVariant: TCVariant = .tw

  var body: some View {
    VStack {
      HStack {
        Text("Traditional Variant:")
        Picker("TPJM", selection: $selVariant) {
          Text("TPJM").tag(TCVariant.tw)
          Text("KangXi").tag(TCVariant.kx)
          Text("TPJM(Idiom)").tag(TCVariant.twidiom)
          Text("HK").tag(TCVariant.hk)
        }
        .labelsHidden()
        .onChange(of: selVariant) { value in
          switch value {
            case TCVariant.kx:
              converterS2T = try! ChineseConverter(options: [.traditionalize])
              converterT2S = try! ChineseConverter(options: [.simplify])
            case TCVariant.twidiom:
              converterS2T = try! ChineseConverter(options: [.traditionalize, .twStandard, .twIdiom])
              converterT2S = try! ChineseConverter(options: [.simplify, .twStandard, .twIdiom])
            case TCVariant.tw:
              converterS2T = try! ChineseConverter(options: [.traditionalize, .twStandard])
              converterT2S = try! ChineseConverter(options: [.simplify, .twStandard])
            case TCVariant.hk:
              converterS2T = try! ChineseConverter(options: [.traditionalize, .hkStandard])
              converterT2S = try! ChineseConverter(options: [.simplify, .hkStandard])
          }
        }
      }
      HStack {
        VStack(alignment: .leading) {
          Text("Simplified Chinese")
          TextEditor(text: $contentCHS).onChange(of: contentCHS) { value in
            contentCHT = converterS2T.convert(value)
          }
          .font(.system(size: 14))
        }
        VStack(alignment: .leading) {
          Text("Traditional Chinese")
          TextEditor(text: $contentCHT).onChange(of: contentCHT) { value in
            contentCHS = converterT2S.convert(value)
          }
          .font(.system(size: 14))
        }
      }
    }
    .frame(minWidth: 640, minHeight: 480)
    .padding()
    .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

enum TCVariant {
  case tw
  case kx
  case twidiom
  case hk
}

// MARK: - Windows Aero in Swift UI

// Ref: https://stackoverflow.com/questions/62461957

@available(macOS 10.15, *)
struct VisualEffectView: NSViewRepresentable {
  let material: NSVisualEffectView.Material
  let blendingMode: NSVisualEffectView.BlendingMode

  func makeNSView(context _: Context) -> NSVisualEffectView {
    let visualEffectView = NSVisualEffectView()
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
    visualEffectView.state = NSVisualEffectView.State.active
    return visualEffectView
  }

  func updateNSView(_ visualEffectView: NSVisualEffectView, context _: Context) {
    visualEffectView.material = material
    visualEffectView.blendingMode = blendingMode
  }
}
