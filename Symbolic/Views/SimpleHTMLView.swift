// Copyright (c) 2022-2023 InSeven Limited
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI

enum Tag: String {

    case h1 = "h1"
    case h2 = "h2"
    case h3 = "h3"
    case html = "html"
    case head = "head"
    case body = "body"
    case title = "title"
    case p = "p"
    case strong = "strong"
    case ol = "ol"
    case li = "li"

}

extension View {

    func style(_ tag: Tag) -> some View {
        VStack {
            switch tag {
            case .h1:
                self
                    .font(.title)
                    .horizontalSpace(.trailing)
            case .h2:
                self
                    .font(.title2)
                    .horizontalSpace(.trailing)
            case .h3:
                self
                    .font(.title3)
                    .horizontalSpace(.trailing)
            case .html, .body:
                self
            case .head:
                self
            case .title:
                self
            case .p:
                self
                    .padding(.bottom)
            case .strong:
                self
                    .fontWeight(.bold)
            case .ol:
                self
            case .li:
                self
            }
        }
    }

}

struct SimpleHTMLView: View {

    let root: XMLElement

    var body: some View {
        VStack(alignment: .leading) {
            if let name = root.name,
               let tag = Tag(rawValue: name) {
                if let children = root.children {
                    ForEach(0..<children.count) { index in
                        let node = children[index]
                        if let element = node as? XMLElement {
                            SimpleHTMLView(root: element)
                                .style(tag)
                        } else {
                            Text("\(node)")
                                .multilineTextAlignment(.leading)
                                .style(tag)
                        }
                    }
                } else {
                    Text("Empty")
                }
            } else {
                Text(root.name ?? "unknown")
            }
        }
        .textSelection(.enabled)
    }

}
