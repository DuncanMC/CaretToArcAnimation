CaretToArcAnimation

This project animates a simple transform of a caret symbol to an arc that spans 3/4 of a circle. It looks like this:

![](CaretToArcAnimation.gif)

It works by animating the path installed into a CAShapeLayer.

In order for a path animation to work correctly, the starting and ending paths need to have the same number and type of control points.

To animate from the caret to the arc, it creates the caret as 2 cubic bezier curves. The first "curve" (Which is actually a straight line) starts at the lower left of the caret, passes through points 1/3 and 2/3 of the way along the lower line segment, and ends at the "bend" in the caret. That creates a Bezier curve that renders as a line segment. The second curve is also a straight line Bezier curve. The second one starts at the bend in the caret and ends at the top left corner.

The arc is also composed of 2 cubic bezier curves, drawn in the same direction as those in the caret symbol. However, the control points for the arc's Bezier curves are chosen so that the resulting curve closely approximates an arc of 3π/2 radians, or 270 degrees, or 3/4 of a cicrcle. The arc is slightly larger than the caret it replaces, and faces the same way.

It's easier to understand if you add a visual representation of the Bezier control points, like this:

![](CaretToArcAnimationWithControlPoints.gif)

The red dots that land on the caret/curve are the endpoints of the 2 Bezier curves. The red dots that are on the outside of the arc are the control points that define the shape of the curves. For the caret shape, the control points are on the lines, which causes the Bezier curve to take a straight line shape.

I used [**this article**](https://pomax.github.io/bezierinfo/#circles_cubic) to get the control points for the two Bezier curves. I didn't feel like figuring out the math, so I just set the curve on that page's interactive arc renderer to draw 3/8 of a circle, wrote down the coordinates of all the control points, and then flipped them to get the second Bezier curve.

Here is a screenshot from the Bezier Arc approximator web simulation I used to find the Bezier control points:

![](BezierArcApproximationScreenshot.png)

(In that screenshot, the angle slider is expressed in radians. One half of a 3/4 circle arc is 3/8 of a full circle, or 3/8 of 2π. 2π * 3/8 is about 2.36, so that is the arc angle I chose.)

The CaretToArcAnimation app defines a `CaretToArcView` class which is a subclass of `UIView`.

Most of the interesting work is done in the `CaretToArcView` class.

It has a static var `layerClass` which returns `CAShapeLayer.self`. This causes the view's backing layer to be set up as a CAShapeLayer.

```    
class override var layerClass: AnyClass {
        return CAShapeLayer.self
    }
```

The CaretToArcView.swift file defines an enum ViewState:

```
enum ViewState: Int {
    case none
    case caret
    case arc
}
```

The custom view class has a var `viewState` of type `ViewState`. Its initial value is `.none`, meaning no path is installed in the view.

If you set the state to `.caret` or `.arc`, it checks to see if the current layer path is nil. If it is, it installs the appropriate path into the layer without animation.

If the previous path was the other path type, it builds a path with the new shape, and creates a `CABasicAnimation` with a `fromState` of the previous path, and `toState` of the new path. The animation's duration is set using an instance variable, `animationDuration`. The animation uses ease-in, ease-out timing, although it would be easy to change.

The class also has public function `rotate(_ doRotate: Bool)`. If you call it with `doRotate == false`, it removes all animations from the view's layer. If you call it with  `doRotate == true`, it adds an infinitely repeating rotation animation to the layer, rotating it 360°, over and over, using linear timing.

The app's view controller drives the settings in the `CaretToArcView`, and it has logic that prevents the custom view from invoking both animations at the same time (Strange things would happen if you did that. Don't.)

The app's screen looks like the image below.

The view controller disables both the button and the switch during a toggle animation, and disables the "Toggle" button when the rotate switch is turned on and the shape is rotating.

![](CaretToArcAnimationScreenshot.png)