
describe "Controller" do
  tests Controller

  it "has a button" do
    controller.instance_variable_get("@button").should.not == nil
  end
end
