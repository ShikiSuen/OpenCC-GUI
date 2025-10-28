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
      Picker("Traditional Variant:", selection: $selVariant) {
        ForEach(TCVariant.allCases) { tcVariantCase in
          tcVariantCase.tagTextView
            .tag(tcVariantCase)
        }
      }
      .pickerStyle(.segmented)
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
      .frame(maxWidth: .infinity, alignment: .leading)
      Divider()
      HStack {
        VStack(alignment: .leading) {
          HStack {
            Text("Simplified Chinese")
            Button("Copy") {
              NSPasteboard.general.clearContents()
              NSPasteboard.general.declareTypes([.string], owner: nil)
              NSPasteboard.general.setString(contentCHS, forType: .string)
            }
            Spacer()
          }
          TextEditor(text: $contentCHS).onChange(of: contentCHS) { value in
            contentCHT = converterS2T.convert(value)
          }
          .font(.system(size: 14))
        }
        VStack(alignment: .leading) {
          HStack {
            Text("Traditional Chinese")
            Button("Copy") {
              NSPasteboard.general.clearContents()
              NSPasteboard.general.declareTypes([.string], owner: nil)
              NSPasteboard.general.setString(contentCHT, forType: .string)
            }
            Spacer()
          }
          TextEditor(text: $contentCHT).onChange(of: contentCHT) { value in
            contentCHS = converterT2S.convert(value)
          }
          .font(.system(size: 14))
        }
      }
    }
    .frame(minWidth: 640, minHeight: 480)
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

enum TCVariant: String, Hashable, Identifiable, CaseIterable {
  case tw
  case kx
  case twidiom
  case hk

  var id: String { rawValue }

  var tagTextView: Text {
    switch self {
    case .tw:
      Text("TPJM")
    case .kx:
      Text("KangXi")
    case .twidiom:
      Text("TPJM(Idiom)")
    case .hk:
      Text("HK")
    }
  }
}
