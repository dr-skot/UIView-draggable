class MockAnyObject 
  attr_accessor :point
  def locationInView(view)
    @point
  end
end

describe "DraggableView" do
  tests UIViewController

  before do
    @view = UIView.alloc.initWithFrame(CGRectMake(0, 0, 50, 50));
    @view.dragBounds = CGRectMake(0, -10, 1000, 110)
    anyObject = MockAnyObject.new
    allTouches = stub(:anyObject, :return => anyObject)
    @event = stub(:allTouches, :return => allTouches)
    controller.view.addSubview(@view)
    @view.draggable = true
  end

  it "starts at 25, 25" do
    @view.center.x.should == 25
    @view.center.y.should == 25
  end

  it "drags when dragged" do
    drag @view, :from => @view.center, :to => CGPointMake(500, 80)
    @view.center.x.should.not == 25
    @view.center.y.should.not == 25
  end

  it "doesn't drag unless draggable" do
    @view.draggable = false
    drag @view, :from => @view.center, :to => CGPointMake(500, 80)
    @view.center.x.should == 25
    @view.center.y.should == 25
  end

  it "doesn't drag past min" do
    drag @view, :from => @view.center, :to => CGPointMake(-10, -100)
    @view.center.x.should == 0
    @view.center.y.should == -10
  end

  it "doesn't drag past max" do
    drag @view, :from => @view.center, :to => CGPointMake(2000, 1400)
    @view.center.x.should == 1000
    @view.center.y.should == 100
  end

  it "can be unbounded" do
    @view.dragBounds = nil
    drag @view, :from => @view.center, :to => CGPointMake(2000, 1400)
    @view.center.x.should > 1000
    @view.center.y.should > 100
  end

  it "is its own handle" do
    @view.dragHandle.should == @view
  end

  it "can't be grabbed anywhere but its handle" do
    button = UIButton.allocate.initWithFrame CGRectMake(0, 0, 100, 100)
    @view.addSubview button
    @view.dragHandle = button
    drag @view, :from => CGPointMake(200, 200), :to => CGPointMake(500, 80)
    @view.center.x.should == 25
    @view.center.y.should == 25
  end

  it "can be grabbed by its handle" do
    button = UIButton.allocate.initWithFrame CGRectMake(0, 0, 10, 100)
    @view.addSubview button
    @view.dragHandle = button
    drag @view, :from => button.center, :to => CGPointMake(500, 80)
    @view.center.x.should.not == 25
    @view.center.y.should.not == 25
  end

  it "sets a drag point after dragging" do
    @view.draggable = true
    drag @view, :from => @view.center, :to => :right
    @view.dragPoint.should.not == nil
  end

  it "notifies drag start" do
    confirmer = mock(:confirm, :return => nil)
    @view.when(:willStartDrag) { confirmer.confirm }
    @view.draggable = true
    drag(@view, :from => @view.center, :to => CGPointMake(500, 80))
    true.should == true
  end

  it "notifies drag stop" do
    confirmer = mock(:confirm, :return => nil)
    @view.when(:didStopDrag) do
      @view.dragging?.should == false
      confirmer.confirm 
    end
    @view.draggable = true
    drag(@view, :from => @view.center, :to => CGPointMake(500, 80))
    true.should == true
  end

  it "notifies while dragging" do
    confirmer = mock(:confirm, :return => nil)
    @view.when(:didDrag) do
      @view.dragging?.should == true
      confirmer.confirm 
    end
    @view.draggable = true
    drag(@view, :from => @view.center, :to => CGPointMake(500, 80))
    true.should == true
  end

  it "has a drag point at willStartDrag" do
    confirmer = mock(:confirm, :return => nil)
    @view.when(:willStartDrag) do
      confirmer.confirm
      @view.dragPoint.should.not == nil
    end
    @view.draggable = true
    drag(@view, :from => @view.center, :to => CGPointMake(500, 80))
    true.should == true
  end

end


