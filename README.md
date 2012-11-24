# UIView-draggable

implements drag on UIViews

## Synopsis

```ruby
@view.draggable = true
@view.when(:willStartDrag) { p "drag starting" }
@view.when(:didDrag) { p "dragging" }
@view.when(:didStopDrag) { p "drag stopped" }
```

You can constrain dragging to a certain rectangle with

```ruby
@view.dragBounds = [0, 100, 320, 100]
```

(@view.center is constrained to this rectangle.)

## Dependencies

Uses my [Observable](https://github.com/dr-skot/RubyMotion-commons/blob/master/Observable.rb) mixin, also available on GitHub.