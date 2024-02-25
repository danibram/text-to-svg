let default_lineHeight = 1.175

module Font = {
  type t

  @get external getUnitsPerEm: t => int = "unitsPerEm"

  module Error = {
    type t
    @send external toString: t => string = "toString"
  }

  type cb = (Nullable.t<Error.t>, t) => unit
  @module("opentype.js") external load: (string, cb) => unit = "load"

  let load = (url: string): Promise.t<result<t, Error.t>> =>
    Promise.make((resolve, _) => {
      load(url, (err, font) => {
        switch err->Nullable.toOption {
        | Some(err) => resolve(Error(err))
        | None => resolve(Ok(font))
        }
      })
    })
}

module Layout = {
  module Glyph = {
    type position
    type origin
    type data
    type t
    @get external getData: t => data = "data"
    @get external getPosition: t => position = "position"
    @get external getOrigin: t => origin = "origin"
  }

  type t
  @get external getGlyphs: t => array<Glyph.t> = "glyphs"

  module Options = {
    type align = [#left | #center | #right]
    type t = {
      align: align,
      lineHeight: float,
      width: float,
      letterSpacing: int,
    }
    let make = (~align, ~lineHeight, ~width, ~letterSpacing): t => {
      align,
      lineHeight,
      width,
      letterSpacing,
    }
  }

  @module("opentype-layout")
  external computeLayout: (Font.t, string, Options.t) => t = "default"

  @module("opentype-layout")
  external computeLayoutFree: (Font.t, string) => t = "default"
}

// opentype.load(url, (err, font) => {
//   if err {
//     this.errorDisplay.innerHTML = err.toString()
//   } else {
//     this.callMakerjs(
//       font,
//       text,
//       size,
//       union,
//       filled,
//       kerning,
//       separate,
//       bezierAccuracy,
//       units,
//       fill,
//       stroke,
//       strokeWidth,
//       strokeNonScaling,
//       fillRule,
//     )
//   }
// })
