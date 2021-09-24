//created by Andrew Smith


import Foundation

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/
//create circle
let circle = OvalShape(width: 40, height: 40)

//create barrier
var barriers: [Shape] = []


//create funnel
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
let funnel = PolygonShape(points:funnelPoints)

//create targets
var targets: [Shape] = []


fileprivate func setupBall() {
    //Add circle to scene
    circle.position = Point(x: 250, y: 400)
    circle.hasPhysics = true
    circle.bounciness = 0.6
    scene.add(circle)
    circle.fillColor = .blue
    circle.onCollision = ballCollided(with:)
    circle.isDraggable = false
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    //Add barrier to scene
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    let barrier = PolygonShape(points:barrierPoints)
    barriers.append(barrier)
    barrier.position = position
    barrier.hasPhysics = true
    barrier.angle = angle
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.fillColor = .brown
}

fileprivate func setupfunnel() {
    //Add a funnel to scene
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false
}

fileprivate func addTarget(at position: Point) {
    //Add target to scene
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    let target = PolygonShape(points:targetPoints)
    targets.append(target)
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"
    scene.add(target)
    target.isDraggable = false
}

func setup() {
    setupBall()
    setupfunnel()
    
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 30, height: 15, angle: -0.2)
    addBarrier(at: Point(x: 300, y: 150), width: 100, height: 25, angle: 0.3)
    
    addTarget(at: Point(x: 133, y: 614))
    addTarget(at: Point(x: 111, y: 474))
    addTarget(at: Point(x: 256, y: 280))
    addTarget(at: Point(x: 151, y: 242))
    addTarget(at: Point(x: 165, y: 40))

    resetGame ()
    scene.onShapeMoved = printPosition(of:)
}

//Drop ball at funnel and for when ball is on screen(ball position/motion, barrier drag and target reset)
func dropBall () {
    circle.position = funnel.position
    circle.stopAllMotion()
    for barrier in barriers {
    barrier.isDraggable = false
    }
    for target in targets {
        target.fillColor = .yellow
    }
}
//Ball collision
func ballCollided (with otherShape: Shape) {
    if otherShape.name != "target" {return}
    otherShape.fillColor = .green
}

//for when ball off screen(barrier drag, target counter and win alert)
func ballExitedScene () {
    scene.trackShape(circle)
    circle.onExitedScene = ballExitedScene
    for barrier in barriers {
    barrier.isDraggable = true
    }
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!", completion: alertDismissed)
    }
    func alertDismissed () {
        
    }
}

//Softlock prevention
func resetGame () {
    circle.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

//Solution (205,508) (86,113) (280,162)
