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