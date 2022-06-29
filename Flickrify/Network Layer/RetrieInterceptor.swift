//
//  RetrieInterceptor.swift
//  Actic
//
//  Created by Siamak Rostami on 5/25/22.
//

import Foundation
import Alamofire

final class RetrierInterceptor : Interceptor {
    private var limit : Int
    private var delay : TimeInterval
    
    init(limit : Int , delay : TimeInterval){
        self.limit = limit
        self.delay = delay
        super.init()
    }
    
    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
    }
    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
    }
}
