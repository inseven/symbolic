// “Commons Clause” License Condition v1.0
//
// The Software is provided to you by the Licensor under the License, as defined
// below, subject to the following condition.
//
// Without limiting other conditions in the License, the grant of rights under the
// License will not include, and the License does not grant to you, the right to
// Sell the Software.
//
// For purposes of the foregoing, “Sell” means practicing any or all of the rights
// granted to you under the License to provide to third parties, for a fee or other
// consideration (including without limitation fees for hosting or consulting/
// support services related to the Software), a product or service whose value
// derives, entirely or substantially, from the functionality of the Software. Any
// license notice or attribution required by the License must also include this
// Commons Clause License Condition notice.
//
// Software: Symbolic
// License: BSD 3-Clause License
// Licensor: InSeven Limited
//
// BSD 3-Clause License
//
// Copyright (c) 2022-2023 InSeven Limited
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import SwiftUI

extension LayoutSubviews {

    typealias SubviewDetails = (LayoutSubviews.Element, CGSize)

    func rows(proposal: ProposedViewSize) -> [[SubviewDetails]] {
        guard let width = proposal.width else {
            return [[]]
        }

        let details = self.map {
            return ($0, $0.sizeThatFits(.unspecified))
        }

        var rows: [[SubviewDetails]] = []
        var row: [SubviewDetails] = []
        var rowWidth: CGFloat = 0
        for (subview, size) in details {
            if rowWidth + size.width > width {
                rows.append(row)
                row = []
                rowWidth = 0.0
            }
            row.append((subview, size))
            rowWidth += size.width
        }
        if !row.isEmpty {
            rows.append(row)
        }
        return rows
    }

}

struct CenteredFlowLayout: Layout {

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = subviews.rows(proposal: proposal)

        let width = rows
            .map { row in
                row.map { subview, size in
                    size.width
                }
                .reduce(0.0, +)
            }
            .reduce(0.0, max)

        let height = rows
            .map { row in
                row.map { subview, size in
                    size.height
                }
                .reduce(0.0, max)
            }
            .reduce(0.0, +)

        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var posY = bounds.minY
        for row in subviews.rows(proposal: proposal) {
            let rowWidth = row.map({ $1.width }).reduce(0.0, +)
            let rowHeight = row.map({ $1.height }).reduce(0.0, max)
            var posX = ((bounds.width - rowWidth) / 2) + bounds.minX
            for (subview, size) in row {
                subview.place(at: CGPoint(x: posX, y: posY + rowHeight),
                              anchor: .bottomLeading,
                              proposal: ProposedViewSize(size))
                posX += size.width
            }
            posY += rowHeight
        }
    }
}
