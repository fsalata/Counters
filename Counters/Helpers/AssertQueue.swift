//
//  AssertQueue.swift
//  Counters
//
//  Created by Fabio Salata on 15/04/22.
//

import Foundation

@inline(__always) @inlinable
public func assertQueue(_ Q: DispatchQueue,
                        file: StaticString = #file, line: UInt = #line) {
  assert(_dispatchPreconditionTest(.onQueue(Q)), file: file, line: line)
}
@inline(__always) @inlinable
public func assertMainQueue(file: StaticString = #file, line: UInt = #line) {
  assert(_dispatchPreconditionTest(.onQueue(DispatchQueue.main)),
         file: file, line: line)
}
