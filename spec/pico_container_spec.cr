require "./spec_helper"

class Dependency
  inject
end

class Example
  inject Dependency
  getter :dependency

  def initialize(@dependency : Dependency)
  end
end

class Container
  include PicoContainer
end

describe PicoContainer do
  it "creates instances of the requested class" do
    container = Container.new
    container.create(Dependency).should be_a(Dependency)
  end

  it "handles creating classes with dependencies" do
    container = Container.new
    example = container.create(Example)
    example.dependency.should be_a(Dependency)
  end
end
