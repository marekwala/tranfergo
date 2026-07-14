//
//  URLSssionProtocol.swift
//  Networking
//
//  Created by Marek Wala on 14/07/2026.
//

import Foundation

public protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
