class UIView
  attr_accessor :dragBounds
  attr_reader :dragPoint

  def draggable?
    @draggable
  end

  def draggable=(draggable)
    return if @draggable == draggable
    if (draggable)
      addTarget(self, action:'wasDragged:withEvent:', 
                forControlEvents:UIControlEventTouchDragInside)
    else
      removeTarget(self, action:'wasDragged:withEvent:', 
                forControlEvents:UIControlEventTouchDragInside)
    end
    @draggable = draggable
  end

  def dragHandle
    if @dragHandle
      @dragHandle
    else
      self
    end
  end
  
  def dragHandle=(handle)
    handle = nil if handle == self
    if (draggable?)
      draggable = false
      @dragHandle = handle
      draggable = true
    else
      @dragHandle = handle
    end
  end

  def wasDragged(sender, withEvent:event)
    point = event.allTouches.anyObject.locationInView(superview)
    x = point.x
    y = point.y
    if (dragBounds)
      xMin = dragBounds.origin.x
      xMax = xMin + dragBounds.size.width
      yMin = dragBounds.origin.y
      yMax = yMin + dragBounds.size.height
      x = xMin if x < xMin
      x = xMax if x > xMax
      y = yMin if y < yMin
      y = yMax if y > yMax
    end
    @dragPoint = CGPointMake(x, y)
    self.center = @dragPoint
  end
end
