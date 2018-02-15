import Foundation
import AdSupport
import CoreTelephony
import UIKit

public class MAXClientError {
    public private(set) var appId: Int64?
    public private(set) var adUnitID: Int64?
    public private(set) var adUnitType: String?
    public private(set) var adSourceId: Int64?
    public private(set) var createdAt: String
    public private(set) var message: String

    private let MAXErrorDomain = "MAXErrorDomain"

    init(message: String) {
        self.message = message
        self.createdAt = Date().description
    }

    var ifa: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }

    var lmt: Bool {
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? false : true
    }

    var vendorId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    var timeZone: String {
        return NSTimeZone.system.abbreviation() ?? ""
    }

    var locale: String {
        return Locale.current.identifier
    }

    var regionCode: String {
        return Locale.current.regionCode ?? ""
    }

    var orientation: String {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            return "portrait"
        } else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            return "landscape"
        } else {
            return "none"
        }
    }

    var deviceWidth: CGFloat {
        return floor(UIScreen.main.bounds.size.width)
    }

    var deviceHeight: CGFloat {
        return floor(UIScreen.main.bounds.size.height)
    }

    var browserAgent: String {
        return MAXUserAgent.shared.value ?? ""
    }

    var connectivity: String {
        if MaxReachability.forInternetConnection().isReachableViaWiFi() {
            return "wifi"
        } else if MaxReachability.forInternetConnection().isReachableViaWWAN() {
            return "wwan"
        } else {
            return "none"
        }
    }

    var carrier: String {
        return CTTelephonyNetworkInfo.init().subscriberCellularProvider?.carrierName ?? ""
    }

    var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    var data: Dictionary<String, Any> {
        return [
            "message": self.message,
            "lmt": self.lmt,
            "ifa": self.ifa,
            "vendor_id": self.vendorId,
            "tz": self.timeZone,
            "locale": self.locale,
            "orientation": self.orientation,
            "w": self.deviceWidth,
            "h": self.deviceHeight,
            "browser_agent": self.browserAgent,
            "connectivity": self.connectivity,
            "carrier": self.carrier,
            "model": self.model
        ]
    }

    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self.data, options: [])
    }

    public func asNSError() -> NSError {
        let userInfo: [String: Any] = [NSLocalizedDescriptionKey: message]
        let errorTemp = NSError(domain: MAXErrorDomain, code:0, userInfo:userInfo)
        return errorTemp
    }
}
