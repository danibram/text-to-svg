@genType
let composeModel = (
  text: string,
  //Font
  ~letterSpacing=0,
  ~font: Opentype.Font.t,
  ~fontSize=16,
  ~lineHeight=Opentype.default_lineHeight,
  //Canvas
  ~align=#left,
  ~canvasWidth=300,
) => {
  let model = MakerJS.makeTextModel(font->OpentypeMakerJS.fontToMaker, "", fontSize)

  let scale = 1.0 /. font->Opentype.Font.getUnitsPerEm->Int.toFloat *. fontSize->Int.toFloat
  let lineHeight = lineHeight *. font->Opentype.Font.getUnitsPerEm->Int.toFloat
  let width = canvasWidth->Int.toFloat /. scale

  let layout = Opentype.Layout.computeLayout(
    font,
    text,
    Opentype.Layout.Options.make(~align, ~lineHeight, ~width, ~letterSpacing),
  )

  layout
  ->Opentype.Layout.getGlyphs
  ->Array.forEachWithIndex((glyph, i) => {
    let character = MakerJS.glyphToModel(
      glyph->Opentype.Layout.Glyph.getData->OpentypeMakerJS.glyphDataToMaker,
      fontSize,
    )
    let newOrigin = MakerJS.scale(
      glyph->Opentype.Layout.Glyph.getPosition->OpentypeMakerJS.positionToMaker,
      scale,
    )
    character->MakerJS.Character.setOrigin(newOrigin)
    MakerJS.addModel(model, character, i)
  })

  model
}
