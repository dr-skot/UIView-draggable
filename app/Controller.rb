class Controller < UIViewController

  def viewDidLoad
    if (!@initialized)
      @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @button.frame = CGRectMake(200, 300, 100, 50)
      @button.dragBounds = CGRectMake(50, 325, view.bounds.size.width-100, 0)
      @button.draggable = true
      view.addSubview(@button)
      @initialized = true
    end
  end
  
end
