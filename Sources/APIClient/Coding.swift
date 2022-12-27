//
//  Coding.swift
//  
//
//  Created by Majd Koshakji on 27/12/22.
//

import Foundation

public protocol EncoderProtocol {

    /// The type this encoder produces.
    associatedtype Output

    /// Encodes an instance of the indicated type.
    ///
    /// - Parameter value: The instance to encode.
    func encode<T>(_ value: T) throws -> Self.Output where T : Encodable
}


public protocol DecoderProtocol {

    /// The type this decoder accepts.
    associatedtype Input

    /// Decodes an instance of the indicated type.
    func decode<T>(_ type: T.Type, from: Self.Input) throws -> T where T : Decodable
}

extension JSONEncoder: EncoderProtocol {}
extension JSONDecoder: DecoderProtocol {}
extension PropertyListEncoder: EncoderProtocol {}
extension PropertyListDecoder: DecoderProtocol {}
