class UIView
  include Observable

  attr_accessor :dragBounds
  attr_reader :dragPoint

  def draggable?
    @draggable
  end

  def draggable=(draggable)
    # p "draggable=#{draggable} when @draggable=#{@draggable}"
    return if @draggable == draggable
    if (draggable)
      # p "adding gesture to #{dragHandle}"
      dragHandle.addGestureRecognizer(panGesture)
    else  
      # p "removing gesture from #{dragHandle}"
      dragHandle.removeGestureRecognizer(panGesture)
    end
    @draggable = draggable
  end

  def dragging?
    @dragging ||= false
  end

  def dragHandle
    @dragHandle || self
  end
  
  def dragHandle=(handle)
    handle = nil if handle == self
    if (self.draggable?)
      self.draggable = false
      @dragHandle = handle
      self.draggable = true
    else
      @dragHandle = handle
    end
  end

  private

  def panGesture
    unless @panGesture
      @panGesture = UIPanGestureRecognizer.alloc.initWithTarget self, action:'handlePanGesture:'
    end
    @panGesture
  end

  def handlePanGesture(sender)
    if sender.state == UIGestureRecognizerStateBegan
      @dragStart = self.center
      @dragPoint = self.center
      fire :willStartDrag
      @dragging = true
    elsif sender.state == UIGestureRecognizerStateEnded
      @dragging = false
      fire :didStopDrag
    else
      translate = sender.translationInView self
      x = @dragStart.x + translate.x
      y = @dragStart.y + translate.y
      if dragBounds
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
      fire :didDrag
    end
  end

end
