type model
type point
type glyphData
type opentypeFont

@ocaml.doc("Options for the SVG exporter. See https://maker.js.org/docs/exporting/#SVG")
module Options = {
  type fillRule = [
    | #evenodd
    | #nonzero
  ]
  type t = {
    fill: string,
    stroke: string,
    strokeWidth: float,
    fillRule: fillRule,
    scalingStroke: bool,
    accuracy: float,
    annotate: bool,
    className: string,
    cssStyle: string,
    scale: float,
    viewbox: bool,
  }

  let make = (
    ~fill="none",
    ~stroke="black",
    ~strokeWidth=0.25,
    ~fillRule=#evenodd,
    ~scalingStroke=true,
    ~accuracy=0.001,
    ~annotate=false,
    ~className="",
    ~cssStyle="",
    ~scale=1.,
    ~viewbox=true,
  ): t => {
    fill,
    stroke,
    strokeWidth,
    fillRule,
    scalingStroke,
    accuracy,
    annotate,
    className,
    cssStyle,
    scale,
    viewbox,
  }
}

module TextModel = {
  type t
  @val @module("makerjs") @scope("exporter")
  external toSVG: (model, Options.t) => string = "toSVG"
}

@new @module("makerjs") @scope("models")
external makeTextModel: (opentypeFont, string, int) => model = "Text"

module Character = {
  type t
  @set external setOrigin: (t, point) => unit = "origin"
}

@val @module("makerjs") @scope(("models", "Text"))
external glyphToModel: (glyphData, int) => Character.t = "glyphToModel"

@val @module("makerjs") @scope("point")
external scale: (point, float) => point = "scale"

@val @module("makerjs") @scope("model")
external addModel: (model, Character.t, int) => unit = "addModel"
