class MockAnyObject 
  attr_accessor :point
  def locationInView(view)
    @point
  end
end

describe "DraggableView" do
  tests UIViewController

  before do
    @view = UIControl.alloc.initWithFrame(CGRectMake(0, 0, 50, 50));
    @view.dragBounds = CGRectMake(0, -10, 1000, 110)
    anyObject = MockAnyObject.new
    allTouches = stub(:anyObject, :return => anyObject)
    @event = stub(:allTouches, :return => allTouches)
    controller.view.addSubview(@view)
  end

  it "starts at 25, 25" do
    @view.center.x.should == 25
    @view.center.y.should == 25
  end

  it "drags when dragged" do
    @event.allTouches.anyObject.point = CGPointMake(500, 80)
    @view.wasDragged(@view, withEvent:@event)
    @view.center.x.should == 500
    @view.center.y.should == 80
  end

  it "doesn't drag past min" do
    @event.allTouches.anyObject.point = CGPointMake(-10, -100)
    @view.wasDragged(@view, withEvent:@event)
    @view.center.x.should == 0
    @view.center.y.should == -10
  end

  it "doesn't drag past max" do
    @event.allTouches.anyObject.point = CGPointMake(2000, 1400)
    @view.wasDragged(@view, withEvent:@event)
    @view.center.x.should == 1000
    @view.center.y.should == 100
  end

  it "can be unbounded" do
    @view.dragBounds = nil
    @event.allTouches.anyObject.point = CGPointMake(2000, 1400)
    @view.wasDragged(@view, withEvent:@event)
    @view.center.x.should == 2000
    @view.center.y.should == 1400
  end

  it "is its own handle" do
    @view.dragHandle.should == @view
  end

  it "doesn't actually drag unless draggable" do
    drag(@view, :from => @view.center, :to => CGPointMake(500, 80))
    @view.center.x.should == 25
    @view.center.y.should == 25
  end

  it "does drag when draggable" do
    @view.draggable = true
    drag(@view, :from => @view.center, :to => CGPointMake(500, 80))
    @view.center.x.should.not == 25
    @view.center.y.should.not == 25
  end

  it "can't be grabbed anywhere but its handle" do
    button = UIButton.allocate.initWithFrame(CGRectMake(0, 0, 10, 10));
    @view.addSubview(button);
    @view.dragHandle = button;
    drag(@view, :from => @view.center, :to => CGPointMake(500, 80));
    @view.center.x.should == 25
    @view.center.y.should == 25
  end

  it "can be grabbed by its handle" do
    button = UIButton.allocate.initWithFrame(CGRectMake(0, 0, 10, 10));
    @view.addSubview(button);
    @view.dragHandle = button;
    drag(@view, :from => button.center, :to => CGPointMake(500, 80));
    @view.center.x.should == 25
    @view.center.y.should == 25
  end

  it "sets a drag point after dragging" do
    drag @view, :from => @view.center, :to => :right
    @dragPoint.should.not == nil
  end

end
