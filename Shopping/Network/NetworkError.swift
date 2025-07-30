//
//  NetworkError.swift
//  Shopping
//
//  Created by Reimos on 7/31/25.
//

import Foundation
// Error 프로토콜
enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case tooManyRequests = 429
    
    case internalServerError = 500
    case notImplemented = 501
    case serviceUnavailable = 503
    
    // 위의 경우를 제외한 알수 없는 에러
    case unknown
    
    // TODO: - 사용자 측면에서 alert 대신 toastMessage는 괜찮은지 고민...
    // alert을 통해 사용자에게 보여줄 타이틀 메시지
    var networkErrorTitle: String {
        switch self {
        case .badRequest:
            return "\(rawValue) 잘못된 요청"
        case .unauthorized:
            return "\(rawValue) 인증 실패"
        case .forbidden:
            return "\(rawValue) 접근 거부"
        case .notFound:
            return "\(rawValue) 페이지 없음"
        case .conflict:
            return "\(rawValue) 요청 충돌"
        case .tooManyRequests:
            return "\(rawValue) 요청 한도 초과"
        case .internalServerError:
            return "\(rawValue) 서버 오류"
        case .notImplemented:
            return "\(rawValue) 지원하지 않는 기능"
        case .serviceUnavailable:
            return "\(rawValue) 서비스 일시 중단"
        case .unknown:
            return "알 수 없는 오류"
        }
    }
    
    // alert을 통해 사용자에게 보여줄 상세 메시지
    var networkErrorDescription: String {
        switch self {
        case .badRequest:
            return "요청이 올바르지 않습니다.\n입력값을 확인해주세요."
        case .unauthorized:
            return "로그인이 필요하거나 인증이 만료되었습니다."
        case .forbidden:
            return "사용할 권한이 없습니다."
        case .notFound:
            return "요청하신 리소스를 찾을 수 없습니다."
        case .conflict:
            return "요청 충돌이 발생했습니다.\n잠시 후 다시 시도해주세요."
        case .tooManyRequests:
            return "요청이 너무 많습니다]\n잠시 후 다시 시도해주세요."
        case .internalServerError:
            return "서버에 문제가 발생했습니다.\n잠시 후 다시 시도해주세요."
        case .notImplemented:
            return "요청한 기능이 지원되지 않습니다."
        case .serviceUnavailable:
            return "현재 서버를 사용할 수 없습니다.\n잠시 후 다시 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

