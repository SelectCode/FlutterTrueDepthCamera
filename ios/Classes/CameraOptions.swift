struct CameraOptions {
    let lensDirection: LensDirection;
    let enableDistortionCorrection: Bool;
    let objectDetectionOptions: ObjectDetectionOptions;
    let preferredFrameRate: PreferredFrameRate;
    let preferredResolution: PreferredResolution;
}

struct ObjectDetectionOptions {
    let minDepth: Double;
    let maxDepth: Double;
    let centerWidthStart: Double;
    let centerWidthEnd: Double;
    let centerHeightStart: Double;
    let centerHeightEnd: Double;
    let minCoverage: Double;
}

struct ObjectDetectionResult {

    var belowLowerBound: Int;
    var aboveUpperBound: Int;
    var leftOfBound: Int;
    var rightOfBound: Int;
    var aboveBound: Int;
    var belowBound: Int;
    var insideBound: Int;
    let boundPointCount: Int;
}

enum PreferredFrameRate {
 case fps24, fps30, fps60, fps120, fps240

    func frameRate() -> Int {
        switch self {
        case .fps24:
            return 24;
        case .fps30:
            return 30;
        case .fps60:
            return 60;
        case .fps120:
            return 120;
        case .fps240:
            return 240;
        }
    }

    func previous() -> PreferredFrameRate? {
        switch self {

        case .fps24:
            return nil
        case .fps30:
            return .fps24
        case .fps60:
            return .fps30
        case .fps120:
            return .fps60
        case .fps240:
            return .fps120
        }
    }
}

enum PreferredResolution {
    case x1920x1080, x640x480
}