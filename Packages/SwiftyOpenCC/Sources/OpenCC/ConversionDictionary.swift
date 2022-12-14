//
//  ConversionDictionary.swift
//  OpenCC
//
//  Created by ddddxxx on 2020/1/3.
//

import copencc
import Foundation

class ConversionDictionary {
  let group: [ConversionDictionary]

  let dict: CCDictRef

  init(path: String) throws {
    guard let dict = CCDictCreateMarisaWithPath(path) else {
      throw ConversionError(ccErrorno)
    }
    group = []
    self.dict = dict
  }

  init(group: [ConversionDictionary]) {
    var rawGroup = group.map(\.dict)
    self.group = group
    dict = CCDictCreateWithGroup(&rawGroup, rawGroup.count)
  }
}
