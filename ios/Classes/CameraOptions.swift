struct CameraOptions {
    let lensDirection: LensDirection;
    let enableDistortionCorrection: Bool;
    let objectDetectionOptions: ObjectDetectionOptions;
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