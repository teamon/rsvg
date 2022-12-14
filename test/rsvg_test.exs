defmodule RSVGTest do
  use ExUnit.Case

  test "render/2" do
    svg = File.read!("test/examples/ubots.svg")
    png = File.read!("test/examples/ubots.png")
    assert RSVG.render(svg, :png) == png
  end

  @tag os: "alpine"
  test "Compile & test on alpine" do
    assert {_, 0} = System.shell("docker build -f test/Dockerfile.alpine .")
  end

  @tag os: "ubuntu"
  test "Compile & test on ubuntu" do
    assert {_, 0} = System.shell("docker build -f test/Dockerfile.ubuntu .")
  end
end
