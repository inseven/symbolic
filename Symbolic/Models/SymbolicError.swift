// Copyright (c) 2022-2023 Jason Barrie Morley
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
