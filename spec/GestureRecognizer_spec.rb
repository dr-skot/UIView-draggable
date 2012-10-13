class MockHandler
  attr_reader :sender
  attr_accessor :handled
  def handleGesture(sender)
    @sender = sender
    @handled = true if sender == "wha" || sender.state == UIGestureRecognizerStateEnded
  end
end

describe "gesture recognizer" do
  
  before do
    @mockTarget = MockHandler.new
    @gr = UIPanGestureRecognizer.alloc.initWithTarget @mockTarget, action: 'handleGesture:'
  end

  it "can satisfy the mock at all" do
    @mockTarget.handleGesture "wha"
    @mockTarget.sender.should == "wha"
    @mockTarget.handled.should == true
  end
  
  describe "gesture recognizer on main view" do
    tests UIViewController
    
    before do
      @mockTarget.handled = false
    end
    
    it "responds to drag gesture" do
      controller.view.addGestureRecognizer(@gr)
      drag controller.view, :from => controller.view.center, :to => CGPointMake(0, 0)
      @mockTarget.handled.should == true
    end
    
    it "responds to drag on a subview" do
      controller.view.addGestureRecognizer(@gr)
      subview = UIView.alloc.initWithFrame([[0, 0], [100, 100]])
      controller.view.addSubview(subview)
      drag subview, :from => subview.center, :to => CGPointMake(0, 0)
      @mockTarget.handled.should == true
    end
    
    it "responds to drag on itself where subview is" do
      controller.view.addGestureRecognizer(@gr)
      subview = UIView.alloc.initWithFrame([[0, 0], [100, 100]])
      controller.view.addSubview(subview)
      drag controller.view, :from => subview.center, :to => CGPointMake(0, 0)
      @mockTarget.handled.should == true
    end
    
    it "responds to drag on a button subview" do
      controller.view.addGestureRecognizer(@gr)
      subview = UIButton.alloc.initWithFrame([[0, 0], [100, 100]])
      controller.view.addSubview(subview)
      drag subview, :from => subview.center, :to => CGPointMake(0, 0)
      @mockTarget.handled.should == true
    end
    
    it "responds to drag on itself where button is" do
      controller.view.addGestureRecognizer(@gr)
      subview = UIButton.alloc.initWithFrame([[0, 0], [100, 100]])
      controller.view.addSubview(subview)
      drag controller.view, :from => subview.center, :to => CGPointMake(0, 0)
      @mockTarget.handled.should == true
    end
    
  end
  
  describe "gesture recognizer on subview of main view" do
    tests UIViewController

    before do
      @subview = UIView.alloc.initWithFrame([[0, 0], [100, 100]])
      controller.view.addSubview(@subview)
      @subview.addGestureRecognizer(@gr)
      @mockTarget.handled = false
    end
      
    it "responds to drag gesture" do
      drag @subview, :from => @subview.center, :to => CGPointMake(0, 0)
      @mockTarget.handled.should == true
    end
    
    it "responds to drag on superview where subview is" do
      drag controller.view, :from => @subview.center, :to => CGPointMake(0, 0)
      @mockTarget.handled.should == true
    end
    
    it "does not respond to drag on superview outside of its bounds" do
      drag controller.view, :from => CGPointMake(200, 200), :to => CGPointMake(300, 300)
      @mockTarget.handled.should == false
    end
    
    it "does not respond to drag on itself outside of its bounds" do
      drag @subview, :from => CGPointMake(200, 200), :to => CGPointMake(300, 300)
      @mockTarget.handled.should == false
    end
    
  end

end
