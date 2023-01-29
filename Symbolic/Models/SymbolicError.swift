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

import Foundation

enum SymbolicError: Error {

    case invalidColorspace
    case exportFailure
    case missingManifest
    case missingLicense
    case unsupportedVersion
    case unknownSymbol

}

extension SymbolicError: LocalizedError {

    var errorDescription: String? {
        return nil
    }

    var failureReason: String? {
        switch self {
        case .invalidColorspace:
            return "Invalid colorspace."
        case .exportFailure:
            return "Export failure."
        case .missingManifest:
            return "Missing library manifest."
        case .missingLicense:
            return "Missing library license."
        case .unsupportedVersion:
            return "Unsupported version."
        case .unknownSymbol:
            return "Unknown symbol."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidColorspace:
            return nil
        case .exportFailure:
            return nil
        case .missingManifest:
            return nil
        case .missingLicense:
            return nil
        case .unsupportedVersion:
            return "Document was created with a later version of Symbolic. Update Symbolic to view and edit this document."
        case .unknownSymbol:
            return nil
        }
    }

}
